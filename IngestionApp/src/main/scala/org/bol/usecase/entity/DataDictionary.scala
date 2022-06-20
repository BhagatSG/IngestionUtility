package org.bol.usecase.entity

case class DataDictionary(line: String) extends Serializable {
  val data = line.split(",")
  var object_type = data(0)
  var input_field_name= data(1)
  var bol_field_name= data(2)
}

