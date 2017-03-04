
object Example {
    /*
    trait TunnelShape[T]
    case class Tunnel[T](x: T) extends TunnelShape[T]
    
    trait TunnelLike { self =>
        type T <: TunnelLike { type T = self.T }
        val toTunnel: TunnelShape[T]
    }
    
    object DepthOne {
        def unapply(t: TunnelLike): Option[t.T] = t.toTunnel match {
            case Tunnel(x) => Some(x)
            case _ => None
        }
    }
    
    object DepthTwo {
        def unapply(t: TunnelLike) = t match {
            case DepthOne(DepthOne(x)) => Some(x)
            case _=> None
        }
    }
    */
   
    trait Foo {
        type T <: Bar
        val it: Option[T]
    }
    object Foo {
        def unapply(f: Foo): Option[f.T] = f.it
    }
    
    trait Bar {
        type T
        val it: Option[T]
    }
    object Bar {
        def unapply(b: Bar): Option[b.T] = b.it
    }
    
    object Both {
        def unapply(f: Foo) = f match {
            case Foo(Bar(x)) => Some(x)
            case _ => None
        }
    }
}

