package com.composum.platform.feature.nodesstarter;

import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Uses the sling feature launcher to start from the embedded feature archive.
 */
public class LaunchFromEmbeddedFAR {

    /**
     * The path to the FAR within the JAR which execute if there is no -f argument given.
     */
    public static final String DEFAULT_SLING_FEATURE_MODEL_FILE_PATH = "/far/embedded.far";

    /**
     * The path to the internal repository we use if there is no -u argument given.
     */
    public static final String DEFAULT_REPOSITORY_PATH_MARKER = "/lib/marker.txt";

    public static void main(String[] rawArgs) {
        List<String> args = new ArrayList<>(Arrays.asList(rawArgs));
        System.out.println("Start arguments " + args);

        if (!args.contains("-f")) {
            URL mainFeatureURL = LaunchFromEmbeddedFAR.class.getResource(DEFAULT_SLING_FEATURE_MODEL_FILE_PATH);
            if (mainFeatureURL == null) {
                throw new IllegalArgumentException("File format is wrong - no embedded file " + DEFAULT_SLING_FEATURE_MODEL_FILE_PATH + " found in JAR");
            }
            System.out.println("Using feature file " + mainFeatureURL);
            args.add("-f");
            args.add(mainFeatureURL.toExternalForm());
        }
        if (!args.contains("-u")) {
            URL repositoryMarkerURL = LaunchFromEmbeddedFAR.class.getResource(DEFAULT_REPOSITORY_PATH_MARKER);
            if (repositoryMarkerURL == null) {
                throw new IllegalArgumentException("File format is wrong - no embedded repository marker " + DEFAULT_REPOSITORY_PATH_MARKER + " found in JAR");
            }
            String repositoryURL = repositoryMarkerURL.toExternalForm().replaceFirst("/marker.txt", "/");
            System.out.println("Using repository " + repositoryURL);
            args.add("-u");
            args.add(repositoryURL);
        }

        System.out.println("Feature launcher start arguments: " + args.stream().collect(Collectors.joining(" ")));
        org.apache.sling.feature.launcher.impl.Main.main(args.toArray(new String[0]));
    }
}
