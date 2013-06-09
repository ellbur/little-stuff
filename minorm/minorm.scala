
package minorm

import scalaz.Scalaz._

// ----------------------------------------------------------
// Records

trait RecordType[R] {
    def construct(fields: List[Any]): R
    def breakup(r: R): List[Any]
    
    val columns: List[Column]
    
    def toRow(r: R): List[Field] =
        breakup(r) zip columns map { case (v, Column(name, mode)) =>
            Field(mode.extract(v))
        }
    
    def fromRow(fields: List[Field]): R = construct {
        fields zip columns map { case (f, Column(_, mode)) =>
            mode.box(f.value)
        }
    }
    
    override def toString = columns.toString
}

case class Column(
        name: String,
        mode: ColumnMode
    )

case class ColumnMode(sqlType: String, extract: Any=>Any, box: Any=>Any)

object modes {
    val table = Map[Class[_],ColumnMode](
        classOf[Int]    -> ColumnMode("INT", identity, identity),
        classOf[String] -> ColumnMode("TEXT", identity, identity)
    )
}

case class Field(value: Any)

// ----------------------------------------------------------
// Tables

class Table[R](name: String, recordType: RecordType[R]) {
    def insert(r: R) {
        val row = recordType toRow r
        println("Inserting " + row)
    }
    
    def update(r: R) {
        val row = recordType toRow r
        println("Updating " + row)
    }
    
    def select(k: Any): R =
        sys.error("Sorry, you can't select yet")
    
    override def toString: String = recordType.toString
}

