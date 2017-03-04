
package test

import org.squeryl
import squeryl.PrimitiveTypeMode._
import squeryl.annotations.Column
import squeryl.{KeyedEntity, SessionFactory, Session, Table}
import squeryl.customtypes.{BigDecimalField,LongField}
import squeryl.adapters.{H2Adapter}
import squeryl.dsl._
import squeryl.dsl.ast._

trait UserSchema {
    self: squeryl.Schema =>
    
    implicit val users = table(() => User("", ""))
    
    case class User(
            id:   String,
            name: String
        )
        extends KeyedEntity[String]
    
}

object Test extends H2Schema with UserSchema {
    def main(args: Array[String]) {
        clearDatabase()
        
        transaction {
            
            users insert User("1", "joe")
            
            println(users lookup "1")
            
        }
    }
}

