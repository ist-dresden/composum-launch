//usr/bin/env jshell --execution local "-q" "-J-Dfile=$1" "$0"; exit $?
/* Scans for new lines of the form "ServiceEvent REGISTERED" in the logfile and exits when there are no such lines
  in the last 10 seconds (variable timeout). This is some indication that the last deployment was finished.
  (Unfortunately there is no really good indicator.) */

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.text.SimpleDateFormat;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.SynchronousQueue;
import java.util.concurrent.TimeUnit;
import java.util.regex.Pattern;
import java.util.Date;

    String filename = System.getProperty("file");
    Pattern regex = Pattern.compile("ServiceEvent REGISTERED|BundleEvent|org.apache.sling.audit.osgi.installer|OsgiInstallerImpl|JcrInstaller|FelixStartLevel|Startup Thread");
    int timeout = 10;
    @SuppressWarnings("rawtypes")
    BlockingQueue linequeue = new SynchronousQueue<Object>();
    File file = new File(filename);
    Thread reader = new Thread() {
        @SuppressWarnings("unchecked")
        @Override
        public void run() {
            try {
                long lastKnownPosition = file.length();
                while (!this.isInterrupted()) {
                    while (!this.isInterrupted() && file.length() == lastKnownPosition) {
                        Thread.sleep(1000);
                    }
                    if (!this.isInterrupted()) {
                        RandomAccessFile randomAccessFile = new RandomAccessFile(file, "r");
                        randomAccessFile.seek(lastKnownPosition);
                        String line = null;
                        while ((line = randomAccessFile.readLine()) != null) {
                            if (regex.matcher(line).find()) {
                                System.out.println(line);
                                linequeue.offer(Boolean.TRUE);
                            }
                        }
                        lastKnownPosition = randomAccessFile.getFilePointer();
                        randomAccessFile.close();
                    }
                }
            } catch (InterruptedException e) { // can't rethrow; since interruption flag was cleared:
                Thread.currentThread().interrupt();
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
            linequeue.offer(Boolean.FALSE);
        }
    };
    try {
        reader.start();
        while (Boolean.TRUE.equals(linequeue.poll(timeout, TimeUnit.SECONDS))) ;
    } finally {
        reader.interrupt();
        Thread.sleep(1000);
    }

    System.out.println(new SimpleDateFormat("dd.MM.YY HH:mm:ss").format(new Date()) + " No service registered log entries for " + timeout + " seconds");

/exit
