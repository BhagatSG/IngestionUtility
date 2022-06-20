# Bol Ingestion Application

This project provides 3 usecases:
1) Spark Scala Batch Ingestion Job
2) Schedule of Batch Ingestion job using crontab
3) Spark Hadoop Local Developement Environment

## Spark Scala Batch Ingestion Job
It is basically spark scala maven project.
features:
1) Data Dictionary feature
2) Data Validation/Filtering
3) Data Enrichment

BolIngestionDriver expects object_type and hdfs location of file from crontab scheduling script.
More details like Build and package inside IngestionApp/README.md


## Job Scheduling TO-DO
We can use crontab for scheduling of Job.
Shell script will check in every 15 minutes whether there is new file in landing zone or not. If there will be new file, first it will push it to HDFS and then will do a spark submit.

Steps in script.sh
1)Check if there is any file in landing zone
2)If found any file, move it to hdfs and trigger spark submit with hdfs path
3)Move file to archive so that it will not get picked up in next schedule

```
export EDITOR=vim
source ~/.bashrc
```
```
first
sudo crontab -e
Under the line
m h  dom mon dow   command
Enter
* 15 * * * sh /path-to-your-script/script.sh
Be sure to make the scipt with execute permission
chmod +x abc.sh
```

Note: We must use Airflow for production deployment. 


## Spark Hadoop Local Developement Environment
Any developer can set up Spark & Hadoop locally on their linux machines for development purposes.
I have created a Makefile carrying all steps.
* Makefile. Used for running various tasks such as starting up the hadoop/spark, running interactive shells for spark etc.
* IngestionApp/ directory. Contains git repositories with file ingestion spark application.
* tools/ directory. Contains hadoop/spark/hive binaries.
* data/ directory contains HDFS data and spark-rdd data.

### Usage

Clone this repository into the folder where you want to create your HDFS/Spark/Hive setup:
```
mkdir -p ~/Workspace/ && cd ~/Workspace/
sudo apt-get update && sudo apt-get -y install git make
git clone https://github.com/BhagatSG/IngestionUtility.git ./
```

### Set up Environment
```
make environment
source ~/.bashrc
```

### Download/Configure HDFS/Spark

```
make download
```

After this step you should have tools/ folder with the following structure:
```
└── tools
    ├── hadoop
    └── spark
```
```
make configure
make configure_hadoop
source ~/.bashrc
make configure_spark
source ~/.bashrc
```

### Start HDFS/Spark
Start hadoop DFS (distributed file system), basically 1 namenode and 1 datanode:
```
start-all.sh
```
