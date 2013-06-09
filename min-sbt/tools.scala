
package object tools {
//

case class Collectable[A](a: A) {
    def collectSome(func: A => Option[A]): List[A] = {
        def iter(a: Option[A], l: List[A]): List[A] = a match {
            case None => l
            case Some(a) => iter(func(a), a :: l)
        }
        
        iter(Some(a), Nil)
    }
}
implicit def toCollectable[A](a: A): Collectable[A] = Collectable(a)

def firstSome[A](func: () => Option[A]): A = {
    func() match {
        case Some(a) => a
        case None => firstSome(func)
    }
}

//
}


