package org.bol.usecase.utils

import org.apache.log4j.Logger
import org.bol.usecase.entity.DataDictionary

import scala.collection.mutable
import scala.io.Source

object BolHelper {
  val log = Logger.getLogger(getClass.getName)

  def readDataDictionary(resourcePath: String): List[DataDictionary] = {
    Source.fromResource(resourcePath).getLines.map(line => DataDictionary(line)).toList
  }

  def readDataValidation(resourcePath: String): Map[String,String] = {
    val validatonMap = collection.mutable.Map.empty[String, String]
    Source.fromResource(resourcePath).getLines.map(line => line.split(";")).toList
      .map(x=> validatonMap.put(x(0),x(1)))
    validatonMap.toMap
  }

  def generateSelectColumnSquery(dataDictionaryList: List[DataDictionary], objectType: String): String = {
     dataDictionaryList.filter(_.object_type.equalsIgnoreCase(objectType))
      .map(x => x.input_field_name + " as " + x.bol_field_name).mkString(",")
  }

}
