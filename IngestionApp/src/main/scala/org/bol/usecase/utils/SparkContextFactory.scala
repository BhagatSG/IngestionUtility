package org.bol.usecase.utils

import org.apache.log4j.Logger
import org.apache.spark.sql.SparkSession

object SparkContextFactory {
  val log = Logger.getLogger(getClass.getName)

  val spark = SparkSession.builder().appName("Bol-Ingestion").master("yarn").enableHiveSupport().getOrCreate()
  spark.conf.set("spark.sql.adaptive.enabled",true)
  spark.conf.set("hive.exec.dynamic.partition", true)
  spark.conf.set("hive.exec.dynamic.partition.mode", "nonstrict")

  def getSparkContext(): SparkSession  = {
    return spark
  }
}