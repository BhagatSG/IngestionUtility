package org.bol.usecase

/**
 * @author ${user.name}
 *         https://stackoverflow.com/questions/27360977/how-to-read-files-from-resources-folder-in-scala
 */
import org.bol.usecase.entity.DataDictionary
import org.bol.usecase.utils.{BolConstants, BolHelper}

import scala.collection.convert.ImplicitConversions.`map AsJavaMap`
import scala.io.Source
object App {
  
  def foo(x : Array[String]) = x.foldLeft("")((a,b) => a + b)
  
  def main(args : Array[String]) {
    println( "Hello World!" )
    println("concat arguments = " + foo(args))

    //val readmeText : Iterator[String] = Source.fromResource("data_dictionary.csv").getLines.map(l => DataDictionary(l))

    //val readmeText : List[DataDictionary] = BolHelper.readDataDictionary("data_dictionary.csv")


    val dataDictionary : List[DataDictionary] = BolHelper.readDataDictionary(BolConstants.DataDictionaryCSV)


    val selectQuery = BolHelper.generateSelectColumnSquery(dataDictionary,"SHOP")
    println(selectQuery)

    val csv = Source.fromResource("data_validation.csv").getLines.map(line => line.split(";")).toList
    val validatonMap = collection.mutable.Map.empty[String, String]

    csv.map(x=> validatonMap.put(x(0),x(1)))

    println(validatonMap.get("SHOP"))

    val test = BolHelper.readDataValidation(BolConstants.DataValidationCSV)

    println(test.get("SHOP"))

    if()
  }


}
