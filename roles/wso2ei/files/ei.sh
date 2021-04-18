#!/bin/sh
# ----------------------------------------------------------------------------

#Find product home location
PRG="$0"
while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '.*/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done

PRGDIR=`dirname "$PRG"`
PRODUCT_HOME=`cd "$PRGDIR/.." ; pwd`

#If JAVA_HOME is not defined, introduce new JAVA_HOME from product home
[ -z "$JAVA_HOME" ] && JAVA_HOME="$PRODUCT_HOME/jdk/jdk8u212-b03"
export JAVA_HOME=$JAVA_HOME

#Start Product
sh $PRODUCT_HOME/bin/integrator.sh $@


