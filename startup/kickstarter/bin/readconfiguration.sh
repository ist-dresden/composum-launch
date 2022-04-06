# sourced to read configuration, including default values
# We read a cpm_config.properties in CPM_HOME
# test with (source bin/readconfiguration.sh ; set | egrep 'CPM|CMD|JAVA|KICK' )

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
fi

if [ -z "$CPM_JARFILE" ]; then
   CPM_JARFILE=`ls -1 starter/*.jar | head -1`
fi

if [ -z "$CPM_FEATUREFILE" ]; then
  CPM_FEATUREFILE=`ls -1 starter/*.far | head -1`
  CPM_FEATUREFILE=file://`realpath $CPM_FEATUREFILE`
fi

if [ -z "$CPM_FEATURES" ]; then
  for fil in features/*; do
    if test -r "$fil"; then
      CPM_FEATURES="$CPM_FEATURES -af=file://$(realpath $fil)"
    fi
  done
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

# --nofm --nofar : do not use embedded FAR - we give that explicitly.
KICKSTART_OPTS="${KICKSTART_OPTS} --nofm --nofar"

KICKSTART_OPTS="${KICKSTART_OPTS} -j=${CPM_CTRL_PORT} -p=${CPM_PORT} -s=${CPM_FEATUREFILE} ${CPM_FEATURES} ${CPM_KICKSTART_OPTS}"
