
package object graph {
//

case class Node(
    val index: Int,
    val edges: Seq[Edge]
)
{
    override def toString: String = "N(%d)" format index
}
object Node {
}

def Graph(nodes: (Int, Seq[Edge])*): Vector[Node] = {
    var c = 0
    val g = nodes map { case (i, edges) =>
        assert(c == i)
        c += 1
        
        Node(i, edges)
    }
    Vector(g:_*)
}

def N(edges: Edge*): Seq[Edge] = edges

case class Edge(
    val to: Int,
    val weight: Double
)
case class Edgeable(to: Int) {
    def x(weight: Double) = Edge(to, weight)
}
implicit def toEdgeable(to: Int) = Edgeable(to)

//
}

