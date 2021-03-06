mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(dir $(mkfile_path))
hadoop_home := $(addsuffix tools/hadoop, $(current_dir))
spark_home := $(addsuffix tools/spark, $(current_dir))


#########################################
#         Environment Set Up            #
#########################################

environment:
	sudo apt-get install -y openjdk-8-jdk
	cat ~/.bashrc
	echo '# Adding Java Home' >>~/.bashrc
	echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >>~/.bashrc
	echo "source ~/.bashrc"


download: download_hadoop download_spark

download_hadoop:
	mkdir -p ${current_dir}tools
	cd ${current_dir}tools; wget https://dlcdn.apache.org/hadoop/common/hadoop-3.2.3/hadoop-3.2.3.tar.gz && tar -xvf *.gz && rm -rf *.gz && mv hadoop-3.2.3 hadoop

download_spark:
	mkdir -p ${current_dir}tools
	cd ${current_dir}tools; wget https://dlcdn.apache.org/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2.tgz && tar -xvf *.tgz && rm -rf *.tgz && mv spark-3.2.1-bin-hadoop3.2 spark


configure:
        #Set JAVA_HOME explicitly
	sed -i "s#.*export JAVA_HOME.*#export JAVA_HOME=${JAVA_HOME}#g" ${hadoop_home}/etc/hadoop/hadoop-env.sh 
	#Set HADOOP_CONF_DIR explicitly
	sed -i "s#.*export HADOOP_CONF_DIR.*#export HADOOP_CONF_DIR=${hadoop_home}/etc/hadoop#" ${hadoop_home}/etc/hadoop/hadoop-env.sh

configure_hadoop:
	#define fs.default.name in core-site.xml
	sed -i '/<\/configuration>/i <property><name>fs.default.name</name><value>hdfs://localhost:9000</value></property>' ${hadoop_home}/etc/hadoop/core-site.xml
	#set dfs.replication, dfs.namenode.name.dir & dfs.datanode.data.dir in hdfs-site.xml
	mkdir -p ${current_dir}data/hadoop/name
	mkdir -p ${current_dir}data/hadoop/data
	sed -i '/<\/configuration>/i <property><name>dfs.replication</name><value>1</value></property>' ${hadoop_home}/etc/hadoop/hdfs-site.xml
	sed -i '/<\/configuration>/i <property><name>dfs.namenode.name.dir</name><value>file://'"${current_dir}"'data/hadoop/name</value></property>' ${hadoop_home}/etc/hadoop/hdfs-site.xml
	sed -i '/<\/configuration>/i <property><name>dfs.datanode.data.dir</name><value>file://'"${current_dir}"'data/hadoop/data</value></property>' ${hadoop_home}/etc/hadoop/hdfs-site.xml
	#set mapreduce.framework.name, mapreduce.reduce.memory.mb & mapreduce.map.memory.mb in mapred-site.xml
	sed -i '/<\/configuration>/i <property><name>mapreduce.framework.name</name><value>yarn</value></property>' ${hadoop_home}/etc/hadoop/mapred-site.xml
	sed -i '/<\/configuration>/i <property><name>mapreduce.reduce.memory.mb</name><value>256</value></property>' ${hadoop_home}/etc/hadoop/mapred-site.xml
	sed -i '/<\/configuration>/i <property><name>mapreduce.map.memory.mb</name><value>256</value></property>' ${hadoop_home}/etc/hadoop/mapred-site.xml
	#set yarn.nodemanager.aux-services, yarn.nodemanager.aux-services.mapreduce.shuffle.class, yarn.nodemanager.disk-health-checker.max-disk-utilization-per-disk-percentage, yarn.nodemanager.resource.memory-mb & yarn.scheduler.minimum-allocation-mb in yarn-site.xml
	sed -i '/<\/configuration>/i <property><name>yarn.nodemanager.aux-services</name><value>mapreduce_shuffle</value></property>' ${hadoop_home}/etc/hadoop/yarn-site.xml
	sed -i '/<\/configuration>/i <property><name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name><value>org.apache.hadoop.mapred.ShuffleHandler</value></property>' ${hadoop_home}/etc/hadoop/yarn-site.xml
	sed -i '/<\/configuration>/i <property><name>yarn.nodemanager.disk-health-checker.max-disk-utilization-per-disk-percentage</name><value>98.0</value></property>' ${hadoop_home}/etc/hadoop/yarn-site.xml
	sed -i '/<\/configuration>/i <property><name>yarn.nodemanager.resource.memory-mb</name><value>12288</value></property>' ${hadoop_home}/etc/hadoop/yarn-site.xml
	sed -i '/<\/configuration>/i <property><name>yarn.scheduler.minimum-allocation-mb</name><value>256</value></property>' ${hadoop_home}/etc/hadoop/yarn-site.xml
	${hadoop_home}/bin/hdfs namenode -format -force
	echo '# Adding Hadoop Home' >>~/.bashrc
	echo 'export HADOOP_HOME='"${hadoop_home}" >> ~/.bashrc
	echo 'export PATH='"${PATH}"':'"${hadoop_home}"'/bin:'"${hadoop_home}"'/sbin' >> ~/.bashrc
	echo "source ~/.bashrc"
	ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
	cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
	chmod 0600 ~/.ssh/authorized_keys

configure_spark:
	# Change logging level from INFO to WARN
	cp ${spark_home}/conf/log4j.properties.template ${spark_home}/conf/log4j.properties
	sed -i "s#log4j.rootCategory=INFO, console#log4j.rootCategory=WARN, console#g" ${spark_home}/conf/log4j.properties
	# Set up Spark environment variables
	echo '# Adding Spark Variables' >>~/.bashrc
	echo 'export SPARK_HOME='"${spark_home}" >> ~/.bashrc
	echo 'export PATH='"${PATH}"':'"${spark_home}"'/bin:' >> ~/.bashrc
	echo "source ~/.bashrc"
