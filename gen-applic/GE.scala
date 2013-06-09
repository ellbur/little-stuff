
object test {
//

sealed trait Bool
case object True extends Bool
case object False extends Bool

trait Or[A<:Bool, B<:Bool] {
    type Res: Bool
}

implicit orFF: Or[False.type,False.type] = new Or { type Res = False.type }
implicit orFT: Or[False.type,True.type]  = new Or { type Res = True.type }
implicit orTF: Or[True.type,False.type]  = new Or { type Res = True.type }
implicit orTT: Or[True.type,True.type]   = new Or { type Res = True.type }

// Never mind!

//
}

