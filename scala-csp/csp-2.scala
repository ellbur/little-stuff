
import scala.util.continuations._

object Test2 {
    
    def main(args: Array[String]) {

        /*
        reset { (x: Int) =>
            shift { (c: Int=>Int=>Int) =>
                c(2)
            }
        }
         */
        
        println {
            (( (c: Int=>Int=>Int) => c(2) ) { (y: Int) =>
                { (x: Int) =>
                    y
                }
            })(1)
        }
    }
}


