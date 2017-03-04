/*
import net.liftweb.json._

object Test3 {
//
    
sealed trait HProd
case class HTimes[+H,+T<:HProd](head: H, tail: T) extends HProd
case class HOne() extends HProd

sealed trait HSum[+A,+B]
case class HLeft[+A,+B](left: A) extends HSum[A,B]
case class HRight[+A,+B](right: B) extends HSum[A,B]
case class HZero() extends HSum[HZero,HZero] { sys.error("Can't create nothing") }

trait Equivalence[A] {
    type B
    def extract(a: A): B
    def compose(b: B): A
}

sealed trait Foo
case class Bar() extends Foo
case class Baz(x: Int, y: Int) extends Foo

implicit def barCon = Bar.apply _
implicit def bazCon = Baz.apply _

implicit def caseProd0[A<:Product](implicit con: () => A) = new Equivalence[A] {
    type B = HOne
    def extract(a: A) = HOne()
    def compose(b: HOne) = con()
}

implicit def caseProd1[A<:Product,X](implicit con: (X) => A) = new Equivalence[A] {
    type B = HTimes[X,HOne]
    def extract(a: A) = a.productIterator.toList match {
        case x::Nil => HTimes(x.asInstanceOf[X],HOne())
    }
    def compose(b: HTimes[X,HOne]) = b match { case HTimes(x,HOne()) =>
        con(x)
    }
}

implicit def caseProd2[A<:Product,X1,X2](implicit con: (X1,X2) => A) = new Equivalence[A] {
    type B = HTimes[X1,HTimes[X2,HOne]]
    def extract(a: A) = a.productIterator.toList match {
        case x1::x2::Nil => HTimes(x1.asInstanceOf[X1],HTimes(x2.asInstanceOf[X2],HOne()))
    }
    def compose(b: HTimes[X1,HTimes[X2,HOne]]) = b match { case HTimes(x1,HTimes(x2,HOne())) =>
        con(x1, x2)
    }
}

type Test[A] = PartialFunction[Any,A]
def test[A:Manifest]: Test[A] = { case a: A => a }

implicit def fooParts = HTimes(test[Bar], HTimes(test[Baz], HOne()))

implicit def oneSum[F] = new Equivalence[F] {
    type B = HZero
    def extract(a: F) = throw MatchError
    def compose(b: B) = throw MatchError
}

implicit def timesSum[F,A<:F,B<:HProd<%Equivalence[F]](implicit l: HTimes[Test[A],B]) =
    l match { case HTimes(ta, b) =>
        try {
        }
        catch { case MatchError =>
        }
    }

implicit val fooSum = new Equivalence[Foo] {
    type B = HSum[Bar,HSum[Baz,HZero]]
    def extract(a: Foo) = a match {
        case a @ Bar()    => HLeft(a)
        case a @ Baz(_,_) => HRight(HLeft(a))
    }
    def compose(b: B) = b match {
        case HLeft(x)         => x
        case HRight(HLeft(x)) => x
    }
}

trait JSONable[A] {
    def serialize(a: A): JValue
    def deserialize(j: JValue): A
}

def toJSON[A:JSONable](a: A) = implicitly[JSONable[A]].serialize(a)
def fromJSON[A:JSONable](j: JValue) = implicitly[JSONable[A]].deserialize(j)

implicit def jInt = new JSONable[Int] {
    def serialize(i: Int)= JInt(i)
    def deserialize(j: JValue) = j match { case JInt(i) => i.intValue }
}

implicit def jOne = new JSONable[HOne] {
    def serialize(a: HOne) = JArray(Nil)
    def deserialize(j: JValue) = j match { case JArray(Nil) => HOne() }
}

implicit def jTimes[H:JSONable,T<:HProd:JSONable] = new JSONable[HTimes[H,T]] {
    def serialize(a: HTimes[H,T]) = a match { case HTimes(h, t) =>
        toJSON(t) match { case JArray(elems) => JArray(toJSON(h)::elems) }
    }
    def deserialize(j: JValue) = j match { case JArray(h :: t) =>
        HTimes(fromJSON[H](h), fromJSON[T](JArray(t)))
    }
}

implicit def jSum[A:JSONable,B:JSONable] = new JSONable[HSum[A,B]] {
    def serialize(a: HSum[A,B]) = a match {
        case HLeft(x) => JArray(JInt(0) :: toJSON(x) :: Nil)
        case HRight(y) => toJSON(y) match {
            case JArray(JInt(n) :: r :: Nil) => JArray(JInt(n+1) :: r :: Nil)
        }
    }
    def deserialize(j: JValue) = j match { case JArray(JInt(n) :: r :: Nil) =>
        n.intValue match {
            case 0        => HLeft(fromJSON[A](r))
            case x if x>0 => HRight(fromJSON[B](JArray(JInt(n-1) :: r :: Nil)))
        }
    }
}

implicit def jZero = new JSONable[HZero] {
    def serialize(a: HZero) = JNothing
    def deserialize(j: JValue) = sys.error("Cannot create nothing from something")
}

implicit def jEquiv[AA,BB](implicit eqv: Equivalence[AA]{type B=BB}, js: JSONable[BB]) = new JSONable[AA] {
    def serialize(a: AA) = toJSON(eqv.extract(a))
    def deserialize(j: JValue) = eqv.compose(fromJSON[BB](j))
}

def main(args: Array[String]) {
    Seq(
        toJSON(new Baz(1, 2): Foo),
        toJSON(new Bar(): Foo),
        fromJSON[Foo](toJSON(new Baz(1, 2): Foo))
    ) foreach println _
}

//
}
*/


