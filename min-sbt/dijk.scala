
import scala.collection.mutable.{PriorityQueue => PQ}
import scala.math.{min, Ordering}

import graph._
import tools._

package object dijk {
//

case class ToSee(
    val node: Node,
    val dist: Double
)
implicit object ToSee extends Ordering[ToSee] {
    def compare(a: ToSee, b: ToSee) = -(a.dist compare b.dist)
}

def findShortest(
    nodes: Vector[Node],
    from:  Node,
    to:    Node
): Option[Seq[Node]] =
{
    val toSee = PQ[ToSee]()
    val dists = nodes map (_ => 1.0/0.0) toArray
    val prev: Array[Option[Node]] =
        nodes map (_ => None) toArray
    val visited: Array[Boolean] = nodes map (_ => false) toArray
    var visitCount: Int = 0
    
    dists(from.index) = 0
    toSee += ToSee(from, 0)
    
    def visit(ts: ToSee): Unit =
        for (edge <- ts.node.edges) {
            val newDist = dists(ts.node.index) + edge.weight
            val newNodeI = edge.to
            
            if (newDist < dists(newNodeI) && !visited(newNodeI)) {
                dists(newNodeI) = newDist
                toSee += ToSee(nodes(newNodeI), newDist)
                prev(newNodeI) = Some(ts.node)
            }
        }
    
    def step(): Option[Option[Seq[Node]]] =
        try {
            if (visitCount >= nodes.length) {
                Some(Some(constructPath))
            }
            else {
                val best = toSee.dequeue
                
                if (! visited(best.node.index)) {
                    visitCount += 1
                    visited(best.node.index) = true
                    visit(best)
                }
                None
            }
        }
        catch { case e: NoSuchElementException =>
            Some(None)
        }
    
    def constructPath: Seq[Node] =
        to collectSome {n => prev(n.index)}
    
    firstSome(step _)
}

//
}

