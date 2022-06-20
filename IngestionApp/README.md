# BolIngestionApp

Spark Scala Batch File Ingestion Job
BolIngestionDriver is the starting point. It expects 2 parameters needs to be passed to it i.e object_type and file hdfs path.

Object type will be shop in our case and file hdfs path will be provided by crontab script during spark submit.

## Data Dictionary:
It contains mapping between input file field name and field name used in Bol application. And it is also scalable if we ingest more object type files.

## Data validation/filtering:
Here in this, we can validate column data and filter also by providing null, in queries for object_type. It is also scalable, needs to add query for other object_type.

## Data Enrichment:
In case needs to modify date formats and mapping fields, we can use this component. It is not yet fully automated and needs to work.


## Working with BolIngestionApp in your IDE

### Prerequisites
The following items should be installed in your system:
* Java 8 or newer.
* git command line tool (https://help.github.com/articles/set-up-git)
* maven installation
* Your prefered IDE 
  * IntelliJ IDEA

### Steps:

1) On the command line
```
git clone https://github.com/BhagatSG/IngestionUtility.git
```
2) Inside IntelliJ IDEA

In the main menu, choose `File -> Open` and select the Report Utility [pom.xml](pom.xml). Click on the `Open` button.

You can build and run it from the command line:

```
git clone https://github.com/BhagatSG/IngestionUtility.git
Go into repo root and run:
Build : 
   mvn clean install
Package :
   mvn package
```

Move the Build Jar to directory you have mentioned in your spark submit in crontab shell script.

TO-DO: can be automated using Makefile for automated deployment.
