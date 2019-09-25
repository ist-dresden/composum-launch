#!/bin/bash

function logdate {
    date -u '+%d.%m.%Y %H:%M:%S'
}

sleep 5

echo `logdate` Preloading: access some URL whose initial generation takes time to improve user experience after startup
# (mostly client libraries)

# This is just a number of URLs copied from the networks tab in the browser that stand out when sorted by descending time
urls="http://localhost:8080/bin/public/clientlibs.min.css/BsL03bOO95I/composum.pages.components.view.css http://localhost:8080/bin/public/clientlibs.min.js/_ND5YvUMdZM/composum.nodes.console.base.js http://localhost:8080/bin/public/clientlibs.min.js/UBU6IONWC2U/composum.nodes.console.browser.js http://localhost:8080/bin/public/clientlibs.min.css/iEAtUR5aC6I/composum.pages.components.edit.css http://localhost:8080/bin/public/clientlibs.min.css/gPCseEvxEPM/composum.pages.edit.page.css http://localhost:8080/bin/public/clientlibs.min.css/2_2a2dkv4dk/composum.pages.edit.frame.css http://localhost:8080/bin/public/clientlibs.min.js/8SBLzWEcTvY/composum.components.view.js http://localhost:8080/bin/public/clientlibs.min.js/VvHzVDbehNk/composum.pages.components.view.js http://localhost:8080/bin/public/clientlibs.min.js/rt1H4ojdRdQ/composum.pages.edit.libs.js http://localhost:8080/bin/public/clientlibs.min.js/FL0Td29bkNo/composum.pages.edit.page.js http://localhost:8080/bin/public/clientlibs.min.js/_mi3dqQDPIY/composum.pages.edit.frame.js http://localhost:8080/bin/pages.html http://localhost:8080/bin/browser.html http://localhost:8080/system/console"

# load everything in parallel to speed things up
for url in $urls; do
  curl -s -S -L -o /dev/null -u admin:admin $url &
done

wait

# load everything again in case something went wrong
sleep 1
for url in $urls; do
  curl -s -S -L -o /dev/null -u admin:admin $url
done

sleep 1
for url in $urls; do
  curl -s -S -L -o /dev/null -u admin:admin $url
done

echo `logdate` Preloading done, have a nice day using Composum!
