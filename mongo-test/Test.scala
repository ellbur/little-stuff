
import com.mongodb.casbah.Imports._

object Test {
    def main(args: Array[String]) {
        val db = MongoConnection()("test_db")
        val pile = db("pile")
        
        pile += MongoDBObject("id" -> "a23", "name" -> "bob")
        
        pile update (MongoDBObject("id" -> "a23"), $set ("name" -> "Bob"))
        
        pile find MongoDBObject("id" -> "a23") foreach ( obj =>
            println(obj("name"))
        )
        
        pile remove MongoDBObject()
    }
}

