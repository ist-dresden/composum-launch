# specifies the urls for preload.sh to fetch. This is separated from preload.sh
# to give an easy possibility to override things.
# we assume there is already a variable urlbase which is e.g. ${urlbase}

# This is just a number of URLs copied from the networks tab in the browser that stand out when sorted by descending time
urls="${urls}
 ${urlbase}/bin/public/clientlibs.min.js/_ND5YvUMdZM/composum.nodes.console.base.js
  ${urlbase}/bin/public/clientlibs.min.js/UBU6IONWC2U/composum.nodes.console.browser.js
    ${urlbase}/bin/browser.html
     ${urlbase}/system/console"
