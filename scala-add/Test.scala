
import up._
import HList._

object Test {
    def main(args: Array[String]) {
        println(-Foo)
    }
}

case object Foo {
    def unary_- = "Hello"
}

