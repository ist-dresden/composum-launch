# Composum starter using feature launcher for the public composum modules

This creates a JAR that contains the Sling Kickstarter and a feature archive containg a Sling Starter 12 and
the public composum projects, so that just executing this JAR will fire up a Composum instance including e.g. Pages and
Assets.

We have for each feature an artifact of type

- osgislingfeature , that contains the feature (JSON)
- far , a feature archive containing the artifacts as well, to avoid network downloads

For both the FAR and osgislingfeature there are the classifers

- composum , which contains the composum artifacts
- oak_tar , containing both the composum artifacts and the Sling Starter in OAK tar configuration.

The composum feature could thus be added to any sling starter. 

Caution: both rely
on [org.apache.sling.extension.content](https://github.com/apache/sling-org-apache-sling-feature-extension-content)
being in the classpath before the Sling feature launcher and
on [org.apache.sling.jcr.packageinit](https://github.com/apache/sling-org-apache-sling-jcr-packageinit) being present as
a feature / bundle for deploying the packages.

## Implementation remarks

### Decision on the import method

There are basically three ways to use the feature launcher.

1. Break the applications down to features without using packages. The problem here is that that would change the
   application structure and we have to provide packages, too, to be interoperable with older Sling versions and AEM. It
   isn't quite clear how to produce features and packages at the same time since they deal with things like
   configurations, repository initialization and content quite differently. So we don't use this.

2. Use the [conversion tool](https://github.com/apache/sling-org-apache-sling-feature-cpconverter) (e.g. with
   the [maven plugin](https://sling.apache.org/components/sling-feature-converter-maven-plugin/plugin-info.html) ) to
   convert the packages to features. This generates bundles and new bundle-free packages from the old packages and is
   thus difficult to update with the normal content packages, and leads to detail problems. So we don't use this either.

3. There is
   an [extension for content-packages](https://github.com/apache/sling-org-apache-sling-feature/blob/master/docs/extensions.md)
   in the feature model, which can be used to import content packages. This can be used to deploy the normal composum
   packages, but has some issues, too, which are discussed in the next section.

### Using the feature extension for content packages

The standard ContentPackageHandler of the Sling feature launcher does, however, not observe the order the packages have
to be installed. (Even worse: it doesn't seem possible to specify a start level when they are installed, and it happened
that they are installed before even the repository was properly initialized with e.g. the service user
sling-package-install.)

So we employ the ContentHandler
of [org.apache.sling.extension.content](https://github.com/apache/sling-org-apache-sling-feature-extension-content) that
makes an execution plan that
triggers [org.apache.sling.jcr.packageinit](https://github.com/apache/sling-org-apache-sling-jcr-packageinit) to install
the packages included in the feature. This has currently a couple of issues, though.

(For the record: there was a workaround for [JCRVLT-517](https://issues.apache.org/jira/browse/JCRVLT-517) that needed 
[SLING-10339](https://issues.apache.org/jira/browse/SLING-10339))

The use of uber-packages with subpackages like platform-package does lead to trouble when deploying a new
version of the package in the server, so that we have to deploy the individual packages. (See stacktrace in appendix).

## Appendix

### Stacktrace when trying to deploy uber-packages

The problem is here that the subpackages are put into the JCR, but their jcr:content nodes don't become vlt:Package
nodes, and thus the packages aren't valid. It's possible that this only happens when I'm trying to install the same
package version as there is in the FSPackageRegistry.

    Caused by: java.lang.NullPointerException
    at org.apache.jackrabbit.vault.packaging.registry.impl.JcrRegisteredPackage.<init>(JcrRegisteredPackage.java:47)
    at org.apache.jackrabbit.vault.packaging.registry.impl.JcrPackageRegistry.open(JcrPackageRegistry.java:253)
    at org.apache.jackrabbit.vault.packaging.impl.JcrPackageImpl.installDependencies(JcrPackageImpl.java:763)
    at org.apache.jackrabbit.vault.packaging.impl.JcrPackageImpl.extract(JcrPackageImpl.java:379)
    at org.apache.jackrabbit.vault.packaging.impl.JcrPackageImpl.extract(JcrPackageImpl.java:356)
    at org.apache.jackrabbit.vault.packaging.impl.JcrPackageImpl.extract(JcrPackageImpl.java:526)
    at org.apache.jackrabbit.vault.packaging.impl.JcrPackageImpl.extract(JcrPackageImpl.java:356)
    at org.apache.jackrabbit.vault.packaging.impl.JcrPackageImpl.install(JcrPackageImpl.java:350)
    at com.composum.sling.core.pckgmgr.PackageJobExecutor$PackageManagerCallable$InstallOperation.doIt(PackageJobExecutor.java:179)
