package com.composum.composumlaunch.it;

import static org.hamcrest.CoreMatchers.containsString;
import static org.hamcrest.CoreMatchers.is;
import static org.hamcrest.MatcherAssert.assertThat;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Base64;

import org.junit.Before;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SmoketestIT {

    private static final Logger LOG = LoggerFactory.getLogger(SmoketestIT.class);

    @Before
    public void waitUntilUp() throws Exception {
        String starterReadyMarker = "Do not remove this comment, used for Starter integration tests";
        Thread.sleep(20000);
        for (int i = 0; i < 20; ++i) {
            try {
                String starterContent = loadUrl("http://localhost:8080/content/starter.html");
                if (starterContent.contains(starterContent)) return;
            } catch (IOException | AssertionError e) {
                LOG.info("Starter not yet ready : {}", e.toString());
            }
            Thread.sleep(5000);
        }
        assertThat(loadUrl("http://localhost:8080/content/starter.html"), containsString(starterReadyMarker));
    }

    /**
     * Verify some health checks. We currently disable oak, since that fails:
     * CRITICAL DataStoreCleanupScheduler Last Status: UNAVAILABLE
     * CRITICAL DataStoreCleanupScheduler Last Message: Cannot perform operation: no service of type BlobGCMBean found.
     */
    @Test
    public void healthCheckOK() throws Exception {
        String result = loadUrl("http://localhost:8080/system/console/healthcheck?tags=*%2C-oak&overrideGlobalTimeout=");
        // these will change once in a while, but we'll see whether that is annoying enough. :-)
        assertThat(result, containsString("8 HealthCheck executed"));
        assertThat(result, containsString("OK All 226 bundles are started"));
    }

    private String loadUrl(String url) throws Exception {
        HttpClient httpClient = HttpClient.newBuilder().followRedirects(HttpClient.Redirect.NORMAL).build();
        String encodedAuth = Base64.getEncoder().encodeToString(("admin" + ":" + "admin").getBytes(StandardCharsets.UTF_8));
        HttpRequest request = HttpRequest.newBuilder(new URI(url)).GET()
                .header("Authorization", "Basic " + encodedAuth) // preemptive auth
                .build();
        HttpResponse<String> body = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        assertThat(body.statusCode(), is(200));
        return body.body();
    }
}
