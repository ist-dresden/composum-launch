# sourced to read configuration, including default values
# We read a cpm_config.properties in CPM_HOME
# debug with (source bin/readconfiguration.sh ; set | egrep 'CPM|CMD|JAVA' )

if [ -z "$CPM_HOME" ]; then
  CPM_HOME=.
fi

cd ${CPM_HOME}

if [ -r conf/cpm_config.properties ]; then
   . conf/cpm_config.properties
fi

if [ -n "$JAVA_VERSION" ]; then
	 unset JAVA_HOME
   export JAVA_HOME=`/usr/libexec/java_home -v $JAVA_VERSION`
   JAVA="${JAVA_HOME}/bin/java"
else
   JAVA=java
fi

if [ -z "$CPM_JARFILE" ]; then
   CPM_JARFILE=`ls -1 starter/*launcher*.jar | head -1`
fi

if [ -z "$CPM_FEATUREFILE" ]; then
  CPM_FEATUREFILE=`ls -1 starter/*.far | head -1`
  # CPM_FEATUREFILE=file://`realpath $CPM_FEATUREFILE`
fi

if [ -z "$CPM_FEATURES" ]; then
  for fil in features/*; do
    if test -r "$fil"; then
      CPM_FEATURES="$CPM_FEATURES -f file://$(realpath $fil)"
    fi
  done
fi

if [ -z "$CPM_REPOSITORIES" ]; then
  # To avoid network access, use the FAR as repository URL.
  add_standard_repos=0
  for feature in $CPM_FEATUREFILE $CPM_FEATURES; do
    if [[ $feature == *.slingosgifeature ]]; then
      add_standard_repos=1
    elif [[ $feature == *.far ]]; then
      CPM_REPOSITORIES="$CPM_REPOSITORIES -u jar:file:$feature!"
    fi
  done

  if [ -z "$CPM_FELIXCONTAINER" ]; then
    CPM_FELIXCONTAINER=`ls -1 starter/*felixcontainer*.zip | head -1`
  fi
  if [ -n "$CPM_FELIXCONTAINER" ]; then
    CPM_REPOSITORIES="$CPM_REPOSITORIES -u jar:file:$CPM_FELIXCONTAINER!"
  fi

  # If there are features besides FAR, also use the normal repositories to retrieve the artifacts
  if [[ $add_standard_repos == 1 ]]; then
    CPM_REPOSITORIES="$CPM_REPOSITORIES -u file:$HOME/.m2/repository -u https://repo.maven.apache.org/maven2 -u https://repository.apache.org/content/groups/snapshots"
  fi
fi

# TCP port used for stop and status scripts
if [ -z "$CPM_PORT" ]; then
   CPM_PORT=9090
fi

# TCP port used for stop and status scripts
if [ -z "$CPM_CTRL_PORT" ]; then
   CPM_CTRL_PORT=19090
fi

# runmode(s)
# will not be used if repository is already present
if [ -z "$CPM_RUNMODE" ]; then
   CPM_RUNMODE='local'
fi

# heap settings
if [ -z "$CPM_HEAP_MIN" ]; then
   CPM_HEAP_MIN='768'
fi
if [ -z "$CPM_HEAP_MAX" ]; then
   CPM_HEAP_MAX='2048'
fi

# default JVM options
if [ -z "$CPM_JVM_OPTS" ]; then
   CPM_JVM_OPTS="-server -Xms${CPM_HEAP_MIN}m -Xmx${CPM_HEAP_MAX}m -Djava.awt.headless=true"
fi

# debug option
if [ "${CPM_DEBUG}" == "true" ]
then
   if [ -z "$CPM_DEBUG_PORT" ]; then
       CPM_DEBUG_PORT=$( expr ${CPM_PORT} + 50 )
   fi
    CPM_JVM_OPTS="${CPM_JVM_OPTS} -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=${CPM_DEBUG_PORT}"
fi

FEATURE_CMD="-f $CPM_FEATUREFILE -D org.osgi.framework.system.packages.extra=sun.misc" # -v for verbose
# FEATURE_CMD="$FEATURE_CMD -p ${CPM_HOME}/sling -c ${CPM_HOME}/sling/cache -u file://${COMPOSUM}/maven/repo,https://build.ist-software.com/nexus/repository/maven-public/"
#FEATURE_CMD="$FEATURE_CMD -D org.osgi.framework.system.packages.extra=sun.misc"

if [ $CPM_HOST ]; then
    FEATURE_CMD="${FEATURE_CMD} -D org.apache.felix.http.host=${CPM_HOST}"
fi
if [ $CPM_PORT ]; then
    FEATURE_CMD="${FEATURE_CMD} -D org.osgi.service.http.port=${CPM_PORT}"
fi
if [ $CPM_CONTEXT ]; then
    FEATURE_CMD="${FEATURE_CMD} -D org.apache.felix.http.context_path=${CPM_CONTEXT}"
fi
if [ $CPM_RUNMODE ]; then
    FEATURE_CMD="${FEATURE_CMD} -D sling.run.modes=${CPM_RUNMODE}"
fi
if [ $CPM_MONGO_URI ]; then
    FEATURE_CMD="${FEATURE_CMD} -D oak.mongo.uri=${CPM_MONGO_URI}"
fi

if [ $CPM_USE_JAAS ]; then
    FEATURE_CMD="${FEATURE_CMD} -D java.security.auth.login.config=${CPM_JAAS_CONFIG}"
fi

FEATURE_CMD="$FEATURE_CMD $CPM_FEATURES $CPM_REPOSITORIES $CPM_FEATURE_OPTS"
