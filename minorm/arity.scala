
package minorm

object casebreak {
    
    implicit def ccRecord[X,C<:Product](con: X=>C)(implicit lf: (X=>C) => ((List[Any]=>C),Int), mf: Manifest[C])
        : RecordType[C]
    = {
        val (make, n) = lf(con)
        
        new RecordType[C] {
            def construct(fields: List[Any]) = make(fields)
            def breakup(c: C) = c.productIterator.toList
            
            val columns = mf.erasure.getDeclaredFields.toList.take(n) map { f =>
                Column(
                    f.getName, modes.table(f.getType)
                )
            }
        }
    }
    
    // ----------------------------------------------------------------
    /// Listifying
    
    implicit def lf1[A,X](f: A => X): (List[Any] => X,Int) = ({ case a::Nil =>
        f(a.asInstanceOf[A])
    },1)
    
    implicit def lf2[A,B,X](f: ((A,B)) => X): (List[Any] => X,Int) = ({ case a::b::Nil =>
        f(a.asInstanceOf[A], b.asInstanceOf[B])
    },2)
    
    implicit def lf3[A,B,C,X](f: ((A,B,C)) => X): (List[Any] => X,Int) = ({ case a::b::c::Nil =>
        f(a.asInstanceOf[A], b.asInstanceOf[B], c.asInstanceOf[C])
    },3)
}

