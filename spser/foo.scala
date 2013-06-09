
object Foo {
//

trait Bar[A] {
    type N
}

trait Baz[A]

implicit def barString = new Bar[String] { type N = Int }
implicit def bazInt = new Baz[Int] { }

def foo[A,B](a: A)(implicit bar: Bar[A]{type N=B}, baz: Baz[B]) = println("Yes")

def main(args: Array[String]) {
    foo("Does it work?")
}

//
}

