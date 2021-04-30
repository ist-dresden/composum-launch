package com.composum.platform.feature.nodesstarter;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

/**
 * Uses the sling feature launcher to start from the embedded feature archive.
 * This takes the same arguments as the <a href="https://github.com/apache/sling-org-apache-sling-feature-launcher">Sling feature launcher</a>
 * and some additional ones: see {@link #OPTION_PIDFILE}, {@link #START_COMMAND}.
 * If there is no feature given or there is a parameter {@code -f default}, we use the feature embedded into the JAR at {@link #DEFAULT_SLING_FEATURE_MODEL_FILE_PATH}.
 * If there is no URL given, or there is a parameter {@code -u default}, we pass as repository URL the embedded directory /lib (see {@link #DEFAULT_REPOSITORY_PATH_MARKER}), which is meant to contain the felix framework in a maven-repository like way.
 * <p> There is also the additional argument form to stop the process: see {@link StopFromPid}. </p>
 *
 * @see StopFromPid
 */
public class LaunchFromEmbeddedFAR {

    /**
     * For consistency with other tools: an optional command that says "start this". Currently just discarded.
     */
    public static final String START_COMMAND = "start";

    /**
     * The path to the FAR within the JAR which execute if there is no -f argument given, or -f default is there.
     */
    public static final String DEFAULT_SLING_FEATURE_MODEL_FILE_PATH = "/far/embedded.far";

    /**
     * The path to the internal repository we use if there is no -u argument given, or -u default is there.
     */
    public static final String DEFAULT_REPOSITORY_PATH_MARKER = "/lib/marker.txt";

    /**
     * Argument to setup a file containing the process id for stopping the app.
     */
    public static final String OPTION_PIDFILE = "--pidfile=";

    List<String> args = new ArrayList<>();
    File pidfile = null;

    public static void main(String[] rawArgs) throws IOException {
        new LaunchFromEmbeddedFAR().run(rawArgs);
    }

    private void run(String[] rawArgs) throws IOException {
        System.out.println("Start arguments " + String.join(" ", Arrays.asList(rawArgs)));
        if (StopFromPid.STOP_COMMAND.equals(rawArgs[0])) {
            StopFromPid.main(rawArgs);
        } else {
            processArgs(rawArgs);
            System.out.println("Feature launcher start arguments: " + String.join("", args));
            org.apache.sling.feature.launcher.impl.Main.main(args.toArray(new String[0]));
        }
    }

    private void processArgs(String[] rawArgs) throws IOException {
        boolean haveFeature = false;
        boolean wantDefaultFeature = false;
        boolean haveRepository = false;
        boolean wantDefaultRepository = false;

        Iterator<String> argIterator = Arrays.asList(rawArgs).iterator();
        while (argIterator.hasNext()) {
            String arg = argIterator.next();
            switch (arg) {
                case START_COMMAND: // currently just ignored
                    continue;
                    
                case "-f":
                    String feature = argIterator.next();
                    if ("default".equalsIgnoreCase(feature)) {
                        wantDefaultFeature = true;
                    } else {
                        haveFeature = true;
                        args.add(arg);
                        args.add(feature);
                    }
                    continue;

                case "-u":
                    String url = argIterator.next();
                    if ("default".equalsIgnoreCase(url)) {
                        wantDefaultRepository = true;
                    } else {
                        haveRepository = true;
                        args.add(arg);
                        args.add(url);
                    }
                    continue;
            }
            if (arg.startsWith(OPTION_PIDFILE)) {
                createPidFile(arg);
                continue;
            }
            args.add(arg); // otherwise just pass it through to the feature launcher.
        }

        if (wantDefaultFeature || !haveFeature) {
            addDefaultFeatureArg();
        }

        if (wantDefaultRepository || !haveRepository) {
            addDefaultRepositoryArg();
        }
    }

    private void createPidFile(String arg) throws IOException {
        String pidfilename = arg.substring(OPTION_PIDFILE.length());
        String pid = String.valueOf(ProcessHandle.current().pid());
        pidfile = new File(pidfilename);
        try (Writer pidWriter = new FileWriter(pidfile)) {
            pidWriter.write(pid);
        } catch (IOException e) {
            System.err.println("Could not write to {}" + pidfile.getAbsolutePath() + " because of " + e);
            throw new IOException("Could not write to {}" + pidfile.getAbsolutePath(), e);
        }
        System.out.println("Created pidfile with our pid " + pid + " at " + pidfile.getAbsolutePath());
        pidfile.deleteOnExit();
    }

    private void addDefaultRepositoryArg() {
        URL repositoryMarkerURL = LaunchFromEmbeddedFAR.class.getResource(DEFAULT_REPOSITORY_PATH_MARKER);
        if (repositoryMarkerURL == null) {
            throw new IllegalArgumentException("File format is wrong - no embedded repository marker " + DEFAULT_REPOSITORY_PATH_MARKER + " found in JAR");
        }
        String repositoryURL = repositoryMarkerURL.toExternalForm().replaceFirst("/marker.txt", "/");
        System.out.println("Using repository " + repositoryURL);
        args.add("-u");
        args.add(repositoryURL);
    }

    private void addDefaultFeatureArg() {
        URL mainFeatureURL = LaunchFromEmbeddedFAR.class.getResource(DEFAULT_SLING_FEATURE_MODEL_FILE_PATH);
        if (mainFeatureURL == null) {
            throw new IllegalArgumentException("File format is wrong - no embedded file " + DEFAULT_SLING_FEATURE_MODEL_FILE_PATH + " found in JAR");
        }
        System.out.println("Using feature file " + mainFeatureURL);
        args.add("-f");
        args.add(mainFeatureURL.toExternalForm());
    }
}
