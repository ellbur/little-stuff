
import java.sql.{Array=>_, _}

object Test5 {
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
def sqlDecode[A,C](c: C)(implicit sql: SQLType[A]{type CT=C}) = sql.decode(c)

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
    def encode(a: A): List[Any]
    def decode(ls: List[Any]): A
    val length: Int
}

def makeSQLParameters[A:SQLParameters](a: A): List[Any] =
    implicitly[SQLParameters[A]].encode(a)

implicit def oneParameters = new SQLParameters[HOne] {
    def encode(i: HOne) = Nil
    def decode(ls: List[Any]) = HOne()
    val length = 0
}

implicit def timesParameters[H,T<:HProd](implicit sql: SQLType[H], rest: SQLParameters[T]) =
    new SQLParameters[HTimes[H,T]]
{
    def encode(p: HTimes[H,T]) = p match {
        case HTimes(h, t) => sqlEncode(h) :: makeSQLParameters(t)
    }
    def decode(ls: List[Any]) = ls match {
        case h :: t => sql.decode(as[sql.CT](h)) :+: rest.decode(t)
        case _      => sys.error("yeah...")
    }
    val length = rest.length + 1
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

trait SQLTable[A] {
    type P
    
    val name: String
    val colNames: List[String]
    val eqv: Equivalence[A] { type B=P }
    val parammer: SQLParameters[P]
    
    val size = parammer.length
    
    def encode(pre: PreparedStatement, a: A) {
        val indices = 1 to parammer.length
        val params = parammer.encode(eqv.extract(a))
        indices zip params foreach { case (n, param) =>
            pre.setObject(n, param)
        }
    }
        
    def getRow(rs: ResultSet): A = {
        val indices = 1 to parammer.length
        val params = (indices map rs.getObject _).toList
        eqv.compose(parammer decode params)
    }
}

class RealSQLTable[A,PP](mf: Manifest[A], val eqv: Equivalence[A]{type B=PP},
        val parammer: SQLParameters[PP])
    extends SQLTable[A]
{
    type P = PP
    
    val name = mf.erasure.getSimpleName
    val colNames = mf.erasure.getDeclaredFields.toList take
        parammer.length map (_.getName)
}

implicit def sqlTable[A,PP](implicit mf: Manifest[A], eqv: Equivalence[A]{type B=PP},
        parammer: SQLParameters[PP]) =
    new RealSQLTable(mf, eqv, parammer)

case class Where(text: String, param: Any)

implicit def whereOps(s: Symbol) = new {
    def ~=~[X](x: X)(implicit field: SQLType[X]) =
        Where("`%s`=?" format s.name, field.encode(x))
}

trait Schema {
    val connection: Connection
    def tables: List[Table[_]] = Nil
    
    private val con = connection
    
    class Table[A](table: SQLTable[A]) {
        val stat = con.createStatement
        
        def create_!() = {
            stat.executeUpdate("drop table if exists `%s`" format table.name)
            stat.executeUpdate("create table `%s` (%s)" format (table.name,
                table.colNames map ("`%s`" format _) mkString ", "
            ))
        }
        
        def insert(a: A) = {
            val pre = con.prepareStatement("insert into `%s` values (%s)" format (table.name,
                Iterator.fill(table.parammer.length)("?") mkString ","
            ))
            table.encode(pre, a)
            pre.executeUpdate()
        }
        
        def updateBy[X](a: A, col: String, eq: X)(implicit field: SQLType[X]) = {
        }
        
        def where(wh: Where) = Query(wh::Nil)
        
        case class Query(wheres: List[Where]) {
            def where(wh: Where) = copy(wheres = wh::wheres)
            
            def toList: List[A] = {
                val rs = executeQuery
                var rows = List[A]()
                
                while (rs.next) rows ::= table.getRow(rs)
                
                rows
            }
            
            def headOption: Option[A] = {
                val rs = executeQuery
                if (rs.next) Some(table.getRow(rs))
                else None
            }
            
            def set(a: A) {
                val pre = con.prepareStatement("update `%s` set %s where %s"
                    format (
                        table.name,
                        table.colNames map (name => "`%s`=?" format name) mkString ", ",
                        wheres map (_.text) mkString " AND "
                    )
                )
            
                // The thing being set
                table.encode(pre, a)
                
                // The WHERE clause
                val indices = (table.size+1) to (table.size+wheres.length)
                indices zip wheres foreach { case (n, Where(_, param)) =>
                    pre.setObject(n, param)
                }
                
                pre.executeUpdate
            }
            
            private def executeQuery = {
                val pre = con.prepareStatement("select * from `%s` where %s"
                    format (table.name, wheres map (_.text) mkString " AND ")
                )
                val indices = 1 to wheres.length
                indices zip wheres foreach { case (n, Where(_, param)) =>
                    pre.setObject(n, param)
                }
                pre.executeQuery
            }
        }
    }
    
    def table[A](implicit table: SQLTable[A]) = new Table(table)
    
    def create_!() { tables foreach (_.create_!) }
}

object schema extends Schema with SQLite with QuxSchema

trait SQLite extends Schema {
    lazy val connection = {
        Class.forName("org.sqlite.JDBC")
        DriverManager.getConnection("jdbc:sqlite:test.db")
    }
}

trait QuxSchema extends Schema {
    val quxes = table[Qux]
    
    abstract override def tables = quxes :: super.tables
}

def main(args: Array[String]) {
    import scala.util.Random
    import schema._
    
    schema.create_!()
    
    quxes insert Qux(1, "two", Random nextInt 5)
    quxes where ('x ~=~ 1) set Qux(1, "TWO", Random nextInt 5)
    println(quxes where ('x ~=~ 1) toList)
}

//
}

