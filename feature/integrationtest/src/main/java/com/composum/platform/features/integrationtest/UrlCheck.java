/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.composum.platform.features.integrationtest;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.ConnectException;
import java.util.Collection;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.codec.Charsets;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NoHttpResponseException;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.protocol.HttpClientContext;
import org.apache.http.impl.client.CloseableHttpClient;

class UrlCheck {

    private final static Log LOG = LogFactory.getLog(UrlCheck.class);

    private final String url;
    private final Pattern containsPattern;

    /** Pattern for special syntax enabling the starter to check that the output contains a line matching a given regex,
     * e.g. /system/console/status-Bundlelist.txt CONTAINS com.composum.nodes.config.*active */
    public static final Pattern CONTAINSCHECK_PATTERN = Pattern.compile("(?<path>.*)\\s+CONTAINS\\s+(?<pattern>.*\\S)");

    /** If this property is set, then the UrlCheck waits for that many milliseconds when a check finally fails.
     * In Integration tests this might help to diagnose the problem, since the server is otherwise stopped immediately after failure. */
    private static final String STARTER_WAITONFAILURE_PROPERTY = "starter.waitonfailure";

    UrlCheck(String baseURL, String path) {
        final String separator = baseURL.endsWith("/") ? "" : "/";
        Matcher containsCheck = CONTAINSCHECK_PATTERN.matcher(path);
        if (containsCheck.matches()) {
            path = containsCheck.group("path");
            containsPattern = Pattern.compile(containsCheck.group("pattern"));
        } else {
            containsPattern = null;
        }
        if (path.startsWith("/")) { // already in baseURL + separator
            path = path.substring(1);
        }
        this.url = baseURL + separator + path;
    }

    String getUrl() {
        return url;
    }

    /**
     * @param response the HttpResponse
     * @return null if check check was successful, an error description otherwise
     * @throws Exception
     */
    String run(HttpResponse response) throws Exception {
        if (containsPattern == null) {
            return null;
        } else {
            HttpEntity entity = response.getEntity();
            if (entity == null) {
                throw new IllegalStateException("Response has no content for url " + url);
            }
            try (InputStream stream = entity.getContent()) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(stream, Charsets.UTF_8), 100000);
                String line;
                while (null != (line = reader.readLine())) {
                    if (containsPattern.matcher(line).find()) {
                        return null;
                    } else {
                        System.out.println(line);
                    }
                }
            }
            return "Pattern not found: " + containsPattern.pattern();
        }
    }

    /** Run all supplied checks */
    static void runAll(CloseableHttpClient client, HttpClientContext httpClientContext, int retryCount, int msecBetweenRetries, Collection<UrlCheck> checks) throws Exception {
        for(UrlCheck check : checks) {
            String lastFailure = null;
            HttpGet get = new HttpGet(check.getUrl());
            int requestCount = 0;
            final long start = System.currentTimeMillis();
            for (int i = 0; i < retryCount; i++) {
                try (CloseableHttpResponse response = client.execute(get, httpClientContext)) {
                    requestCount++;
                    if (response.getStatusLine().getStatusCode() != 200) {
                        lastFailure = "Status code is " + response.getStatusLine();
                        Thread.sleep(msecBetweenRetries);
                        continue;
                    }
    
                    lastFailure = check.run(response);
                    if (lastFailure == null) {
                        break;
                    }
                } catch ( ConnectException | NoHttpResponseException e ) {
                    lastFailure = e.getClass().getName() + " : " + e.getMessage();
                }
    
                Thread.sleep(msecBetweenRetries);
            }
            
            if(lastFailure != null) {
                String errorMessage = String.format("Starter not ready or path not found after %d tries (%d msec). Request to URL %s failed with message '%s'",
                        requestCount,
                        System.currentTimeMillis() - start,
                        check.getUrl(),
                        lastFailure);

                String waitTimeStr = System.getProperty(STARTER_WAITONFAILURE_PROPERTY, "");
                if (!waitTimeStr.trim().isEmpty()) {
                    long waitTime = Long.valueOf(waitTimeStr);
                    if (waitTime > 0) {
                        LOG.error("FAILURE; waiting for " + waitTime + "ms for diagnostic purposes: " + errorMessage);
                        Thread.sleep(waitTime);
                        LOG.info("Continuing.");
                    }
                }

                throw new RuntimeException(
                        errorMessage);
            }
        }
    }

}
