# author mjaglan@umail.iu.edu
# Coding Style: Shell form

# Start from Ubuntu OS image
FROM ubuntu:16.04

# set root user
USER root

# install utilities on up-to-date node
RUN apt-get update && apt-get -y dist-upgrade && apt-get install -y openssh-server wget openjdk-8-jdk vim scala python3 python3-pip && pip3 install py4j


# set java home
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# setup ssh with no passphrase
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
	&& chmod 0600 ~/.ssh/authorized_keys

# add user for hadoop
RUN useradd -ms /bin/bash hadoop

# download & extract & move hadoop & clean up
RUN wget -O /hadoop.tar.gz -q http://ftp.man.poznan.pl/apache/hadoop/common/hadoop-3.1.2/hadoop-3.1.2.tar.gz \
	&& tar -xzvf hadoop.tar.gz \
	&& mv /hadoop-3.1.2 /usr/local/hadoop \
	&& rm /hadoop.tar.gz

RUN wget -O /hive-2.3.4.tar.gz -q https://archive.apache.org/dist/hive/hive-2.3.4/apache-hive-2.3.4-bin.tar.gz \
        && mkdir /home/hadoop/hive-2.3.4 \
        && tar -xzvf hive-2.3.4.tar.gz -C /home/hadoop/hive-2.3.4 --strip-components=1 \
        && rm /hive-2.3.4.tar.gz
	
RUN wget -O /spark-2.4.3.tgz -q http://ftp.man.poznan.pl/apache/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz \
        && mkdir /home/hadoop/spark-2.4.3 \
        && tar -xvf /spark-2.4.3.tgz -C /home/hadoop/spark-2.4.3 --strip-components=1 \
        && rm /spark-2.4.3.tgz	

# hadoop environment variables
ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV YARN_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV HADOOP_INSTALL=$HADOOP_HOME

# spark env conf
ENV SPARK_HOME=/home/hadoop/spark-2.4.3
ENV PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
ENV PATH=$PATH:$SPARK_HOME/bin
ENV PYSPARK_PYTHON=python3

# hadoop-store
RUN mkdir -p $HADOOP_HOME/hdfs/namenode \
	&& mkdir -p $HADOOP_HOME/hdfs/datanode

# setup configs - [standalone, pseudo-distributed mode, fully distributed mode]
# NOTE: Directly using COPY/ ADD will NOT work if you are NOT using absolute paths inside the docker image.
# Temporary files: http://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s18.html
COPY config/ /tmp/
# RUN mv /tmp/ssh_config $HOME/.ssh/config \
RUN mv /tmp/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh \
    && mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml \
    && mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml \
    && mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml.template \
    && cp $HADOOP_HOME/etc/hadoop/mapred-site.xml.template $HADOOP_HOME/etc/hadoop/mapred-site.xml \
    && mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml \
	&& mv /tmp/example.txt /home/hadoop/example.txt \
	&& mkdir /home/hadoop/data

# Add benchmark & startup script
COPY scripts/hadoop-benchmark.sh $HADOOP_HOME/hadoop-benchmark.sh
COPY scripts/hadoop-services.sh $HADOOP_HOME/hadoop-services.sh

# set permissions
# RUN chmod 711 -R $HADOOP_HOME

# format namenode
RUN $HADOOP_HOME/bin/hdfs namenode -format

# Hive environment variables
ENV HIVE_HOME=/home/hadoop/hive-2.3.4
ENV PATH=$PATH:$HIVE_HOME/bin

# create Hive directories in hdfs and copy init configuration
RUN mv /tmp/hive-env.sh $HIVE_HOME/conf/hive-env.sh \
	&& mv /tmp/hive-site.xml $HIVE_HOME/conf/hive-site.xml
 
# init Derby database
RUN cd $HIVE_HOME && rm /home/hadoop/hive-2.3.4/lib/log4j-slf4j-impl-2.6.2.jar && bin/schematool -initSchema -dbType derby

ENTRYPOINT /bin/sh $HADOOP_HOME/hadoop-services.sh && /bin/bash

EXPOSE 9870

EXPOSE 8088

EXPOSE 4040

