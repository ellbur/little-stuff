
object Test4 {
//
    
sealed trait HProd
case class HTimes[+H,+T<:HProd](head: H, tail: T) extends HProd
case class HOne() extends HProd

sealed trait HSum[+A,+B]
case class HLeft[+A,+B](left: A) extends HSum[A,B]
case class HRight[+A,+B](right: B) extends HSum[A,B]
case class HZero() extends HSum[HZero,HZero] { sys.error("Can't create nothing") }

implicit def hBuild[H<:HProd](h: H) = new {
    def :+:[A](x: A) = HTimes[A,H](x, h)
}

trait Equivalence[A] {
    type B
    def extract(a: A): B
    def compose(b: B): A
}

def a[T]: T = sys.error("This got called")

def as[T](a: Any) = a.asInstanceOf[T]

sealed trait Foo
case class Bar() extends Foo
case class Baz(x: Int, y: Int) extends Foo
case class Qux(x: Int, y: String, z: Int) extends Foo

implicit def barCon = Bar.apply _
implicit def bazCon = Baz.apply _
implicit def quxCon = Qux.apply _

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

implicit def caseProd3[A<:Product,X1,X2,X3](implicit con: (X1,X2,X3) => A) = new Equivalence[A] {
    type B = HTimes[X1,HTimes[X2,HTimes[X3,HOne]]]
    def extract(a: A) = a.productIterator.toList match {
        case x1::x2::x3::Nil => as[X1](x1) :+: as[X2](x2) :+: as[X3](x3) :+: HOne()
    }
    def compose(b: B) = b match { case HTimes(x1,HTimes(x2,HTimes(x3,HOne()))) =>
        con(x1, x2, x3)
    }
}

case object Impossible extends RuntimeException

trait SQLType[A] {
    type CT
    val name: String
    def encode(a: A): CT
    def decode(a: CT): A
}

def sqlDataType[A:SQLType] = implicitly[SQLType[A]].name
def sqlEncode[A:SQLType](a: A) = implicitly[SQLType[A]].encode(a)

implicit val sqlInt = new SQLType[Int] {
    type CT = Int
    val name = "INT"
    def encode(i: Int) = i
    def decode(a: Int) = a
}

implicit val sqlString = new SQLType[String] {
    type CT = String
    val name = "TEXT"
    def encode(s: String) = s
    def decode(s: String) = s
}

trait SQLParameters[A] {
    def parameterize(a: A): List[Any]
}

def makeSQLParameters[A:SQLParameters](a: A): List[Any] =
    implicitly[SQLParameters[A]].parameterize(a)

implicit def oneParameters = new SQLParameters[HOne] {
    def parameterize(i: HOne) = Nil
}

implicit def timesParameters[H:SQLType,T<:HProd:SQLParameters] =
    new SQLParameters[HTimes[H,T]]
{
    def parameterize(p: HTimes[H,T]) = p match {
        case HTimes(h, t) => sqlEncode(h) :: makeSQLParameters(t)
    }
}

case class Column(dataType: String)

trait SQLColumns[A] {
    def columns: List[Column]
}

def makeColumns[A:SQLColumns] = implicitly[SQLColumns[A]].columns

implicit def oneColumns = new SQLColumns[HOne] {
    def columns = Nil
}

implicit def timesColumns[H:SQLType,T<:HProd:SQLColumns] =
    new SQLColumns[HTimes[H,T]]
{
    def columns = Column(sqlDataType[H]) :: makeColumns[T]
}

def defineTable[A<:Product,P](a: => A)
    (implicit mf: Manifest[A], eqv: Equivalence[A]{type B=P}, cols: SQLColumns[P]) =
{
    val types = cols.columns
    val names = mf.erasure.getDeclaredFields.toList take
        types.length map (_.getName)
    
    names zip types map { case (name, Column(dataType)) =>
        "%s: %s" format (name, dataType)
    } mkString ", "
}

def main(args: Array[String]) {
    println(makeSQLParameters(1 :+: "two" :+: 3 :+: HOne()))
    println(makeColumns[HTimes[Int,HTimes[String,HTimes[Int,HOne]]]])
    
    println(defineTable(a[Qux]))
}

//
}

