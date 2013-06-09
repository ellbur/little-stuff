
import minorm._
import casebreak._

import java.sql._

object Test {
    
    case class User(
            id: String,
            name: String
        )
    
    def main(args: Array[String]) {
        val table = new Table("users", User.tupled)
        println(table)
        
        table insert User("1", "joe")
        table insert User("2", "bob")
        table update User("1", "Joe")
        
        // ----------------------------------
        
        Class.forName("org.sqlite.JDBC")
        val conn = DriverManager getConnection "jdbc:sqlite:foo.db"
        val stat = conn.createStatement
        
        stat.executeUpdate(
    }
}

