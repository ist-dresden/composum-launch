package com.composum.platform.feature.nodesstarter;

import static org.hamcrest.CoreMatchers.is;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;

import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.ErrorCollector;

/**
 * This tests some command line processing for {@link LaunchFromEmbeddedFAR}. Specifically:
 * <ul>
 *     <li>no feature or -f default -> /far/embedded.far is present</li>
 *     <li>no url given or -u default -> -u embedded /lib is present</li>
 * </ul>
 */
// -f embedded  uses the embedded feature archive if present. It's always used if no other explicit -f argument is given.
// -u embedded  uses the embedded repository containing the felix framework. It's always used if no other explicit -u argument is given - the network won't be used to retrieve features if no explicit other -u argument is given.
public class LaunchFromEmbeddedFARTest {

    @Rule
    public ErrorCollector ec = new ErrorCollector();

    @Test
    public void processArgs() throws IOException {
        ec.checkThat(argsFor(""), is("-f jar:file:launcher.jar!/far/embedded.far -u jar:file:launcher.jar!/lib/"));
        ec.checkThat(argsFor("-f embedded"), is("-f jar:file:launcher.jar!/far/embedded.far -u jar:file:launcher.jar!/lib/"));
        ec.checkThat(argsFor("-u embedded"), is("-f jar:file:launcher.jar!/far/embedded.far -u jar:file:launcher.jar!/lib/"));
        // ec.checkThat(argsFor("-f something.far"),
                // is("-f something.far -u jar:file:launcher.jar!/lib/ -u jar:file:something.far -u jar:file:launcher.jar!/lib/"));
        // ec.checkThat(argsFor("-f something.slingosgifeature"), is("-f something.slingosgifeature -u jar:file:launcher.jar!/lib/ ----"));
    }

    /**
     * Calls the argument processing of the launcher. The  -fv 7.0.3 is removed since it isn't very relevant for this test.
     */
    String argsFor(String rawargs) throws IOException {
        String[] splittedArgs = rawargs.split("\\s+");
        LaunchFromEmbeddedFAR launch = new LaunchFromEmbeddedFAR() {
            @Override
            protected String getRepositoryURL() {
                // jar:file:/Users/hps/dev/composum/composum-launch/feature/nodesstarter/target/composum-launcher-feature-nodesstarter-1.3.0-SNAPSHOT-oak_tar-launcher.jar!/lib/
                return "jar:file:launcher.jar!/lib/";
            }

            @Override
            protected URL getMainFeatureURL() {
                // jar:file:/Users/hps/dev/composum/composum-launch/feature/nodesstarter/target/composum-launcher-feature-nodesstarter-1.3.0-SNAPSHO T-oak_tar-launcher.jar!/far/embedded.far
                try {
                    return new URL("jar:file:launcher.jar!/far/embedded.far");
                } catch (MalformedURLException e) { // impossible
                    throw new AssertionError(e);
                }
            }
        };
        launch.processArgs(splittedArgs);
        String result = String.join(" ", launch.args).trim().replaceAll(" -fv 7.0.3", "");
        // code generator to quickly generate tests
        System.out.println("        ec.checkThat(argsFor(\"" + rawargs + "\"),\n                is(\"" + result + "\"));");
        return result;
    }
}
