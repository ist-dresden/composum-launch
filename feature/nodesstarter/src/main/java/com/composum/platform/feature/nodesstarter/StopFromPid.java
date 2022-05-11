package com.composum.platform.feature.nodesstarter;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.Arrays;
import java.util.Objects;
import java.util.Optional;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import static com.composum.platform.feature.nodesstarter.LaunchFromEmbeddedFAR.OPTION_PIDFILE;

/**
 * Takes a pidfile generated by {@link LaunchFromEmbeddedFAR} from its arguments and kills that process if it's java and then deletes the pidfile.
 * The arguments have to be: {@code stop --pidfile={pidfilepath}}.
 * Mostly for integration tests etc.
 */
public class StopFromPid {

    /**
     * Expected first argument.
     */
    public static final String STOP_COMMAND = "stop";

    public static void main(String[] args) throws Exception {
        stopFromPid(args);
    }

    public static void stopFromPid(String[] arg) throws IOException, ExecutionException, InterruptedException, TimeoutException {
        if (arg.length != 2 || !STOP_COMMAND.equalsIgnoreCase(arg[0]) || !arg[1].startsWith(OPTION_PIDFILE)) {
            throw new IllegalArgumentException("Expecting arguments " + STOP_COMMAND + " " + OPTION_PIDFILE + "{pidfilepath} but got: " + Arrays.toString(arg));
        }
        String pidfilename = arg[1].substring(OPTION_PIDFILE.length());
        File pidfile = new File(pidfilename);
        long pid = getPid(pidfile);

        Optional<ProcessHandle> processOption = ProcessHandle.of(pid);
        if (processOption.isEmpty() || !processOption.get().isAlive()) {
            pidfile.deleteOnExit();
            System.out.println("Process " + pid + " was already terminated.");
        } else {
            ProcessHandle process = processOption.get();
            String command = process.info().command().orElse("<unknown>");
            String commandLine = command + " " + process.info().arguments().map(Arrays::asList).map(Objects::toString).orElse("");
            System.out.println("Process for " + pid + " is " + commandLine);
            if (!command.contains("java")) {
                throw new IllegalArgumentException("Process " + pid + " command doesn't contain java - ignoring: " + commandLine);
            }
            if (!process.destroy()) {
                throw new IllegalStateException("Process " + pid + " could not be killed");
            }

            try {
                process.onExit().get(60, TimeUnit.SECONDS);
            } catch (InterruptedException | ExecutionException | TimeoutException e) {
                System.out.println("Not terminated after 60 seconds -> terminate hard because we received " + e);
                process.destroyForcibly();
                try {
                    process.onExit().get(10, TimeUnit.SECONDS);
                } catch (InterruptedException | ExecutionException | TimeoutException e2) {
                    // Very strange. No idea what to do.
                    throw new IOException("Could not terminate process " + pid, e);
                }
                if (e instanceof InterruptedException) {
                    throw e;
                }
            } finally {
                if (!process.isAlive()) {
                    pidfile.deleteOnExit();
                    System.out.println("Process " + pid + " is now terminated.");
                }
            }
        }
    }

    private static long getPid(File pidfile) throws IOException {
        if (!pidfile.exists() || !pidfile.isFile() || !pidfile.canRead()) {
            throw new IllegalArgumentException("Cannot read pidfile " + pidfile.getAbsolutePath());
        }
        long pid;
        try (FileReader reader = new FileReader(pidfile)) {
            pid = Long.parseLong(new BufferedReader(reader).readLine());
        }
        return pid;
    }

}
