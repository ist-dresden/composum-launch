# specifies the urls for preload.sh to fetch. This is separated from preload.sh
# to give an easy possibility to override things.
# we assume there is already a variable urlbase which is e.g. ${urlbase}

# This is just a number of URLs copied from the networks tab in the browser that stand out when sorted by descending time
urls="${urls} ${urlbase}/bin/pages.html/content/ist/composum
  ${urlbase}/bin/pages.html/content/ist/composum/home
  ${urlbase}/ist/composum/home.html
  ${urlbase}/bin/pages.html/content/ist/testsites/testingsite
  ${urlbase}/bin/pages.html/content/ist/testsites/testingsite/home
  ${urlbase}/ist/testsites/testingsite/home.html"
