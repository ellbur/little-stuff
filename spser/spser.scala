
object Test {
//
    
sealed trait HProd
case class HTimes[+H,+T<:HProd](head: H, tail: T) extends HProd
case class HOne() extends HProd

sealed trait HSum[+A,+B<:HSum[_,_]]
case class HLeft[+A](left: A) extends HSum[A,Nothing]
case class HRight[+B<:HSum[_,_]](right: B) extends HSum[Nothing,B]

trait HProdable[A] {
    type P <: HProd
    def extract(a: A): P
    def compose(p: P): A
}

trait HSumable[A] {
    type S <: HSum[_,_]
    def extract(a: A): S
    def compose(s: S): A
}

sealed trait Foo
case class Bar() extends Foo
case class Baz(x: Int, y: Int) extends Foo

implicit val fooSum = new HSumable[Foo] {
    type S = HSum[Bar,HSum[Baz,Nothing]]
    def extract(a: Foo) = a match {
        case a @ Bar()    => HLeft(a)
        case a @ Baz(_,_) => HRight(HLeft(a))
    }
    def compose(a: S) = a match {
        case HLeft(x)         => x
        case HRight(HLeft(x)) => x
    }
}

implicit val barProd = new HProdable[Bar] {
    type P = HOne
    def extract(a: Bar) = HOne()
    def compose(a: HOne) = Bar()
}

implicit val bazProd = new HProdable[Baz] {
    type P = HTimes[Int, HTimes[Int, HOne]]
    def extract(a: Baz) = HTimes(a.x, HTimes(a.y, HOne()))
    def compose(a: P) = a match { case HTimes(x, HTimes(y, HOne())) =>
        Baz(x, y)
    }
}

trait Show[A] {
    def show(a: A): String
}
def doShow[A:Show](a: A) = implicitly[Show[A]].show(a)

implicit def showInt = new Show[Int] {
    def show(a: Int) = a.toString
}

implicit def showOne = new Show[HOne] {
    def show(a: HOne) = "*"
}

implicit def showTimes[A:Show,B<:HProd:Show] = new Show[HTimes[A,B]] {
    def show(a: HTimes[A,B]) = a match { case HTimes(h, t) =>
        doShow(h) + " :: " + doShow(t)
    }
}

implicit def showProdable[A,PR](implicit p: HProdable[A]{type P=PR}, s: Show[PR]) = new Show[A] {
    def show(a: A) = s show (p extract a)
}

def main(args: Array[String]) {
    println {
        doShow { new Baz(1, 2) }
    }
}

//
}

