#!/bin/bash
echo "RUN service ssh start"
service ssh start
echo "HADOOP SERVICES"
$HADOOP_HOME/sbin/stop-dfs.sh
$HADOOP_HOME/sbin/stop-yarn.sh
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
echo "RUN jps - Java Virtual Machine Process Status Tool"
jps -lm
echo "Get basic filesystem information and statistics."
hdfs dfsadmin -report
hdfs dfsadmin -safemode leave
$HADOOP_HOME/bin/hadoop fs -rm -r -f /user/benchmarks
if $($HADOOP_HOME/bin/hadoop fs -test -d /user/input); then echo "/user/input already exists"; else $HADOOP_HOME/bin/hadoop fs -mkdir -p /user/input; fi
if $($HADOOP_HOME/bin/hadoop fs -test -d /user/hive/warehouse); then echo ""; else hadoop fs -mkdir -p /user/hive/warehouse \
        && hadoop fs -mkdir /tmp \
        && hadoop fs -chmod g+w /user/hive/warehouse \
        && hadoop fs -chmod g+w /tmp; fi
