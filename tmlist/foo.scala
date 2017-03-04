
object test {
//

sealed trait TMList {
    self =>
    type Of
    def :::(x: Of) = new TMCons {
        type Of = self.Of
        val head = x
        val tail: self.type = self
    }
}
abstract class TMNil extends TMList
def ATMNil[A] = new TMNil { type Of = A }
abstract class TMCons extends TMList {
    self =>
    val head: Of
    val tail: TMList { type Of = self.Of }
}

//
}

