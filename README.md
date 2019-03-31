# Run Hadoop 3.1.2 on Ubuntu 16.04 inside docker container in Pseudo-distributed mode

## How to Run
- Go to your terminal.
- Navigate to directory with `Dockerfile` and build image
	```
	docker build -t <image_name> .
	```
	While building a benchmark script is executed.
- Run the following command
	```
	docker run -p 9870:9870 -p 8088:8088 -v <host-directory>:/home/hadoop/data -it --name=container_name <image_name>
	```
	Runs Hadoop startup script and bash on `ENTRYPOINT`.

## TODO
- Add execution of `stop-dfs.sh` and `stop-yarn.sh` at shutdown as described in [here](https://unix.stackexchange.com/questions/146756/forward-sigterm-to-child-in-bash/146770#146770)
- Solve `mesg: ttyname failed: Inappropriate ioctl for device` issue during benchmark execution

## Configuration References
- [Apache Hadoop 3.1.2 docs](https://hadoop.apache.org/docs/r3.1.2/)
- [core-default.xml](https://hadoop.apache.org/docs/r3.1.2/hadoop-project-dist/hadoop-common/core-default.xml)
- [hdfs-default.xml](https://hadoop.apache.org/docs/r3.1.2/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml)
- [mapred-default.xml](https://hadoop.apache.org/docs/r3.1.2/hadoop-mapreduce-client/hadoop-mapreduce-client-core/mapred-default.xml)
- [yarn-default.xml](https://hadoop.apache.org/docs/r3.1.2/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)
- [DeprecatedProperties.html](https://hadoop.apache.org/docs/r3.1.2/hadoop-project-dist/hadoop-common/DeprecatedProperties.html)

