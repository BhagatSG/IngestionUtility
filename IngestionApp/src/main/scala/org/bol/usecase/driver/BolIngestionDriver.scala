package org.bol.usecase.driver

import org.apache.log4j.Logger
import org.bol.usecase.entity.DataDictionary
import org.bol.usecase.utils.{BolConstants, BolHelper, SparkContextFactory}
import org.apache.spark.sql.functions._

object BolIngestionDriver extends Serializable {
  val log = Logger.getLogger(getClass.getName)

  def main(args: Array[String]): Unit = {
    log.info("objectType ###### " + args(0) + " ###### hdfsLocation ###### " + args(1))
    val objectType = args(0).toUpperCase()
    val hdfsLocation = args(1)
    val hdfsPath = BolConstants.HDFSOutputPath + objectType

    log.info("Spark Context set up #####################################")
    val spark = SparkContextFactory getSparkContext

    log.info("Reading Files from HDFS Location")
    val readDF = spark.read.options(Map("inferSchema"->BolConstants.TRUE,"delimiter"->BolConstants.CSVDelimiter,
      "header"->BolConstants.TRUE)).csv(hdfsLocation)
    readDF.createOrReplaceTempView(objectType)

    log.info("Loading Data Dictionary")
    val dataDictionary : List[DataDictionary] = BolHelper.readDataDictionary(BolConstants.DataDictionaryCSV)

    log.info("Generating Select Query with Data Dictionary for Object type")
    val columnQuery = BolHelper.generateSelectColumnSquery(dataDictionary, objectType)
    val selectQuery = "select "+columnQuery+" from "+objectType

    log.info("generating DF with updated Bol Field name from Data Dictionary")
    var finalDF = spark.sql(selectQuery)

    log.info("Loading Data validation into a Map")
    val valMap = BolHelper.readDataValidation(BolConstants.DataValidationCSV)
    val filterQuery = valMap.getOrElse(objectType,"")

    log.info("Data Filtering ")
    if(!filterQuery.isEmpty()) {
      finalDF = finalDF.filter(filterQuery)
    }

    log.info("Data Enrichment --> Date Formatting, Date Column and As of Date Column")
    finalDF = finalDF.withColumn("last_update",to_timestamp(col("last_update"), "dd/MM/yyyy HH:mm"))
      .withColumn("updated_date", date_format(to_date(col("last_update")),"yyyyMMdd"))
      .withColumn("as_of_date",date_format(current_date(),"yyyyMMdd"))


    log.info("Storing it in HDFS with as_of date partition after Data Filtering, Validation and Enrichment")
    finalDF.write
      .option("header","true")
      .partitionBy("as_of_date")
      .mode(BolConstants.OVERWRITE)
      .parquet(hdfsPath)

  }
}
