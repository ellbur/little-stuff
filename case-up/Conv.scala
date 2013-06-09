
package up

import up._
import HList._
import KList._
import ~>._

package object conv {
//

implicit def hlistify1[T1,A](m: (T1) => A): (T1:+:HNil) => A = {
    case t1:+:HNil => m(t1)
}

implicit def hlistify2[T1,T2,A](m: (T1,T2) => A): (T1:+:T2:+:HNil) => A = {
    case t1:+:t2:+:HNil => m(t1, t2)
}

//
}


