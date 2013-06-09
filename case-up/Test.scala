
package main

import up._
import HList._
import up.conv._

object Test {
    
    case class Foo(x: Int, y: Int)
    
    def pairify[A](c: (Int:+:Int:+:HNil) => A, a: Int, b: Int): A =
        c(a :+: b :+: HNil)
    
    def main(args: Array[String]) {
        println(pairify(Foo, 1, 2))
    }
}

