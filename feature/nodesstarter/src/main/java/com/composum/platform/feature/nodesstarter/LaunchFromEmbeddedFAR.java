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

    boolean haveFeature = false;
    boolean wantDefaultFeature = false;
    boolean haveRepository = false;
    boolean wantDefaultRepository = false;
    boolean wantHelp = false;

    public static void main(String[] rawArgs) throws IOException {
        new LaunchFromEmbeddedFAR().run(rawArgs);
    }

    protected void run(String[] rawArgs) throws IOException {
        System.out.println("Start arguments " + String.join(" ", Arrays.asList(rawArgs)));
        if (rawArgs.length > 0 && StopFromPid.STOP_COMMAND.equals(rawArgs[0])) {
            StopFromPid.main(rawArgs);
        } else try {
            processArgs(rawArgs);
            System.out.println("Feature launcher start arguments: " + String.join(" ", args));
            org.apache.sling.feature.launcher.impl.Main.main(args.toArray(new String[0]));
        } finally {
            System.out.flush();
        }
    }

    protected void processArgs(String[] rawArgs) throws IOException {

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

                case "-?":
                case "-h":
                case "--help":
                    wantHelp = true;
                    // go on: add this to command line so that it's invalid and help is printed.
                    break;

                default:
                    if (arg.startsWith(OPTION_PIDFILE)) {
                        createPidFile(arg);
                        continue;
                    }
                    break;
            }
            args.add(arg); // otherwise just pass it through to the feature launcher.
        }

        if (wantHelp) {
            printHelp();
        } else {

            if (wantDefaultFeature || !haveFeature) {
                addDefaultFeatureArg();
            }

            if (wantDefaultRepository || !haveRepository) {
                addDefaultRepositoryArg();
            }

        }
    }

    protected void printHelp() {
        System.out.println("\n\nComposum Nodes Launcher based on Sling Feature launcher.");
        System.out.println("Additional arguments:");
        System.out.println("-h / -? / --help \tprint help");
        System.out.println("-f default\tuses the embedded feature archive if present. It's always used if no other explicit -f argument is given.");
        System.out.println("-u default\tuses the embedded repository containing the felix framework. It's always used if other explicit -u argument is given - the network won't be used to retrieve features if no explicit other -u argument is given.");
        System.out.println();
    }

    protected void createPidFile(String arg) throws IOException {
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

    protected void addDefaultRepositoryArg() {
        URL repositoryMarkerURL = LaunchFromEmbeddedFAR.class.getResource(DEFAULT_REPOSITORY_PATH_MARKER);
        if (repositoryMarkerURL == null) {
            throw new IllegalArgumentException("File format is wrong - no embedded repository marker " + DEFAULT_REPOSITORY_PATH_MARKER + " found in JAR");
        }
        String repositoryURL = repositoryMarkerURL.toExternalForm().replaceFirst("/marker.txt", "/");
        System.out.println("Using repository " + repositoryURL);
        args.add("-u");
        args.add(repositoryURL);
    }

    /**
     * Adds the argument for the embedded default feature. Having no embedded default feature can be OK, if only the
     * embedded default repository is to be used.
     */
    protected void addDefaultFeatureArg() {
        URL mainFeatureURL = LaunchFromEmbeddedFAR.class.getResource(DEFAULT_SLING_FEATURE_MODEL_FILE_PATH);
        if (mainFeatureURL == null) {
            // this might be OK if the user just wants help. If we throw an exception, the command line help is never
            // printed.
            System.out.println("WARNING: no feature given and no default feature archive is found in the launcher jar!");
        } else {
            System.out.println("Using feature file " + mainFeatureURL);
            args.add("-f");
            args.add(mainFeatureURL.toExternalForm());
        }
    }
}
