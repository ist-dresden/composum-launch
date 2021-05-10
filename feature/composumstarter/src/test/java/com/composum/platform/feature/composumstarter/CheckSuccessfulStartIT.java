package com.composum.platform.feature.composumstarter;

import org.apache.commons.lang3.StringUtils;
import org.apache.http.HttpHost;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.client.config.RequestConfig;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.protocol.HttpClientContext;
import org.apache.http.impl.auth.BasicScheme;
import org.apache.http.impl.client.BasicAuthCache;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import shaded.org.apache.commons.io.IOUtils;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class CheckSuccessfulStartIT {

    private static final Logger LOG = LoggerFactory.getLogger(CheckSuccessfulStartIT.class);

    /**
     * The minimum of expected bundles that are up when test is successful.
     */
    private static final int EXECTED_BUNDLECOUNT = 240;

    /**
     * The maximum time (milliseconds) we wait for the server to come up.
     */
    public static final int MAXIMUM_WAIT_TIME = 60000;

    /**
     * System property that tells us about the http port.
     */
    public static final String HTTP_PORT_SYSPROPERTY = "starter.http.port";

    int port;

    private HttpClientContext httpClientContext;
    private CloseableHttpClient client;

    @Before
    public void setup() throws InterruptedException {
        port = Integer.parseInt(System.getProperty(HTTP_PORT_SYSPROPERTY));
        LOG.info("Checking port {}", port);

        CredentialsProvider credsProvider = new BasicCredentialsProvider();
        UsernamePasswordCredentials creds = new UsernamePasswordCredentials("admin", "admin");
        credsProvider.setCredentials(new AuthScope("localhost", port), creds);

        BasicAuthCache authCache = new BasicAuthCache();
        BasicScheme basicAuth = new BasicScheme();
        authCache.put(new HttpHost("localhost", port, "http"), basicAuth);

        httpClientContext = HttpClientContext.create();
        httpClientContext.setCredentialsProvider(credsProvider);
        httpClientContext.setAuthCache(authCache);

        client = HttpClientBuilder.create()
                .setDefaultRequestConfig(
                        RequestConfig.custom()
                                .setConnectTimeout(MAXIMUM_WAIT_TIME / 10)
                                .setSocketTimeout(MAXIMUM_WAIT_TIME / 10)
                                .setConnectionRequestTimeout(MAXIMUM_WAIT_TIME / 10)
                                .build()
                )
                .build();
    }

    @After
    public void teardown() throws IOException, InterruptedException {
        client.close();
        Thread.sleep(100);
        System.out.flush(); // make sure last log messages are written before test ends.
    }

    /**
     * Check that http://localhost:8080/system/console/status-Bundlelist.txt has >=240 bundles which are all active, and contains com.composum.platform.htl, which is one of the last things deployed from composum.
     * "Status: 240 bundles in total - all 240 bundles active."
     */
    @Test
    public void checkBundles() throws InterruptedException, IOException {
        Thread.sleep(5000); // give server some undisturbed startup time

        HttpGet get = new HttpGet("http://localhost:" + port + "/system/console/status-Bundlelist.txt");
        String lastFailure = null;
        long delay = 2000;
        long begin = System.currentTimeMillis();
        while (System.currentTimeMillis() < begin + MAXIMUM_WAIT_TIME) {
            LOG.info("Delaying {}", delay);
            Thread.sleep(delay);
            delay = delay * 9 / 8;

            try (CloseableHttpResponse httpResponse = client.execute(get, httpClientContext)) {

                if (httpResponse.getStatusLine().getStatusCode() != 200) {
                    lastFailure = "Status code is " + httpResponse.getStatusLine();
                    LOG.info("Delaying after failure {}", lastFailure);
                    continue;
                }

                String response = IOUtils.toString(httpResponse.getEntity().getContent(), "UTF-8");
                if (!response.contains("Bundlelist:")) {
                    LOG.info("Response is not yet the bundle list: {}", StringUtils.abbreviate(response, 200));
                    continue;
                }

                Matcher m = Pattern.compile("all (\\d+) bundles active").matcher(response);
                if (m.find()) {
                    int bundlecount = Integer.parseInt(m.group(1));
                    if (bundlecount < EXECTED_BUNDLECOUNT) {
                        LOG.info("Only {} bundles found yet", bundlecount);
                        continue;
                    } else {
                        LOG.info("Found {} bundles", bundlecount);
                    }
                }

                if (!response.contains("com.composum.platform.htl")) {
                    LOG.info("Composum HTL bundle not yet found");
                    continue;
                }

                lastFailure = null;
                LOG.info("Server came up successfully in about {} seconds", Math.round((System.currentTimeMillis() - begin) / 1000));
                break;
            } catch (IOException e) {
                lastFailure = e.getClass().getName() + " : " + e.getMessage();
                LOG.info("Still getting exception reading bundlelist from IT testserver {}", lastFailure);
            }
        }

        checkServiceHookExecution();

        Assert.assertNull(lastFailure);
    }

    /**
     * Checks that
     * http://localhost:8080/bin/cpm/usermanagement.tree.json/home/users/system/composum/platform
     * contains an entry about composum-platform-service to check that the platform SetupHook was executed.
     * Not done as a test in itself, since we rely on {@link #checkBundles()} to ensure the server is up.
     */
    protected void checkServiceHookExecution() throws IOException, InterruptedException {
        HttpGet get = new HttpGet("http://localhost:" + port + "/bin/cpm/usermanagement.tree.json/home/users/system/composum/platform");
        String lastFailure = null;
        long delay = 500;
        long begin = System.currentTimeMillis();
        while (System.currentTimeMillis() < begin + MAXIMUM_WAIT_TIME) {
            LOG.info("Delaying {}", delay);
            Thread.sleep(delay);
            delay = delay * 5 / 3;
            try (CloseableHttpResponse httpResponse = client.execute(get, httpClientContext)) {

                if (httpResponse.getStatusLine().getStatusCode() != 200) {
                    lastFailure = "Status code is " + httpResponse.getStatusLine();
                    LOG.info("Delaying user check after failure {}", lastFailure);
                    continue;
                }

                String response = IOUtils.toString(httpResponse.getEntity().getContent(), "UTF-8");

                if (!response.contains("\"composum-platform-service\"")) {
                    LOG.info("User composum-platform-service not yet found");
                    continue;
                }

                lastFailure = null;
                LOG.info("User composum-platform-service present after {} more seconds", Math.round((System.currentTimeMillis() - begin) / 1000));
                break;
            }
        }
    }

}
