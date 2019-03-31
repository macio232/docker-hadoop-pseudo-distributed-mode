# Run Hadoop 3.1.2 on Ubuntu 16.04 inside docker container in Pseudo-distributed mode

## How to Run
- Go to your terminal.
- Run the following command
	```
	docker run -p 9870:9870 -p 8088:8088 -it --name=container_name hadoop_pdm

## Configuration References
- [Apache Hadoop 3.1.2 docs](https://hadoop.apache.org/docs/r3.1.2/)
- [core-default.xml](https://hadoop.apache.org/docs/r3.1.2/hadoop-project-dist/hadoop-common/core-default.xml)
- [hdfs-default.xml](https://hadoop.apache.org/docs/r3.1.2/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml)
- [mapred-default.xml](https://hadoop.apache.org/docs/r3.1.2/hadoop-mapreduce-client/hadoop-mapreduce-client-core/mapred-default.xml)
- [yarn-default.xml](https://hadoop.apache.org/docs/r3.1.2/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)
- [DeprecatedProperties.html](https://hadoop.apache.org/docs/r3.1.2/hadoop-project-dist/hadoop-common/DeprecatedProperties.html)

