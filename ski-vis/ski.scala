
import prefuse._
import prefuse.data._
import prefuse.visual._
import prefuse.visual.tuple._
import prefuse.controls._
import scala.collection.mutable.{Set => MSet}

trait SKI {
    val graph: Graph
    val visualization: Visualization
    
    def refresh() {
        visualization.run("repaint")
        visualization.run("color")
        visualization.run("layout")
    }
    
    val allFormulas = MSet[Formula]()
    
    var hoverFormula: Option[Formula] = None
    var hoverOperator: Set[Formula] = Set()
    var hoverOperand: Set[Formula] = Set()
    
    def formulaForNode(n: Node) = {
        val res = allFormulas filter (_.node == n) headOption
        
        res match {
            case None =>
                println("Did not find " + n + "!!!!")
            case _ =>
        }
        
        res
    }
    
    val hoverListener = new HoverActionControl("") {
        override def itemEntered(item: VisualItem, ev: java.awt.event.MouseEvent) {
            val preUpdate = hoverOperator ++ hoverOperand ++ hoverFormula.toList
            
            item match {
                case n: TableNodeItem =>
                    println("Entering " + n)
                    val active = formulaForNode(n.getSourceTuple.asInstanceOf[Node])
                    for (active <- active) {
                        hoverFormula = Some(active)
                        hoverOperator = Set(active.operator.toList: _*)
                        hoverOperand = Set(active.operands: _*)
                        
                        println("hoverFormula = " + hoverFormula)
                        (preUpdate ++ hoverOperator ++ hoverOperand ++ hoverFormula.toList) foreach (_.updateState)
                    }
                    
                case _ =>
            }
        }
        
        override def itemExited(item: VisualItem, ev: java.awt.event.MouseEvent) {
            item match {
                case n: TableNodeItem =>
                    val active = formulaForNode(n.getSourceTuple.asInstanceOf[Node])
                    (hoverFormula, active) match {
                        case (Some(a), Some(b)) if (a == b) =>
                            val toUpdate = hoverOperator ++ hoverOperand  ++ hoverFormula.toList
                            hoverOperator = Set()
                            hoverOperand = Set()
                            hoverFormula = None
                            
                            toUpdate foreach (_.updateState)
                        case _ =>
                    }
                case _ =>
            }
        }
    }
    
    class Box(var formula: Formula) {
        val sources: MSet[Pair] = MSet()
        
        def node = formula.node
        def completion = formula.completion
        
        def apply(b: Box) = new Box(new Pair(this, b))
        
        def reduce() {
            completion match {
                case CS3(s, a, b, c) => reduceS(s, a, b, c)
                case CK2(k, a, b)    => reduceK(k, a, b)
                case _ =>
            }
        }
        
        def reduceS(s: Leaf, a: Formula, b: Formula, c: Formula) {
        }
        
        def reduceK(k: Leaf, a: Formula, b: Formula) {
            
        }
    }
    
    sealed trait Formula {
        val node: Node
        def completion: Completion
        def operator: Option[Formula]
        def operands: List[Formula]
        def reduce(): Unit
        
        def updateState() {
            println("State-updating " + this)
            
            val state =
                if (hoverOperator contains this) 2
                else if (hoverOperand contains this) 3
                else if (completion.actionable) 1
                else 0
            
            node.setInt("state", state)
            refresh
        }
        
        allFormulas += this
    }
    
    class Pair(val car: Box, val cdr: Box) extends Formula {
        val node = graph.addNode
        
        node.setString("label", "?")
        node.setInt("type", PAIR_TYPE)
        node.setBoolean("car", false)
        node.setInt("state", 0)
        
        val carLink = new CarLink(this, car)
        val cdrLink = new CdrLink(this, cdr)
        
        var completion: Completion = CompletionUnknown
        def updateCompletion() {
            completion match {
                case CompletionUnknown => recalculateCompletion
                case _ =>
            }
        }
        def recalculateCompletion() {
            val carCompletion = car.completion
            completion = carCompletion successor cdr.formula
            node.setString("label", completion.name)
            updateState
        }
        
        def operator = completion match {
            case CS3(s, a, b, c) => Some(s)
            case CK2(k, a, b) => Some(k)
            case _ => None
        }
        def operands = completion match {
            case CS3(s, a, b, c) => List(a, b, c)
            case CK2(k, a, b) => List(a, b)
            case _ => Nil
        }
        
        override def toString = "([%s] %s %s)" format (
            completion.name,
            car.toString,
            cdr.toString
        )
        
        recalculateCompletion
    }
    
    class Leaf(val combinator: Combinator) extends Formula {
        val node = graph.addNode
        val completion = combinator.completion(this)
        
        node.setString("label", combinator.name)
        node.setInt("type", LEAF_TYPE)
        node.setBoolean("car", false)
        node.setInt("state", 0)
        
        def operator = None
        def operands = Nil
        
        def reduce() { }
        
        override def toString = combinator.name
    }

    class CarLink(val source: Pair, val target: Box) {
        val edge = graph.addEdge(source.node, target.node)
        edge.setInt("type", 0)
        edge.setBoolean("car", true)
    }
    class CdrLink(val source: Pair, val target: Box) {
        val edge = graph.addEdge(source.node, target.node)
        edge.setInt("type", 1)
        edge.setBoolean("car", false)
    }

    sealed trait Combinator {
        val name: String
        def completion(l: Leaf): Completion
    }
    case object SComb extends Combinator { val name = "S" ; def completion(l: Leaf) = CS(l) }
    case object KComb extends Combinator { val name = "K" ; def completion(l: Leaf) = CK(l) }
    
    def S = new Box(new Leaf(SComb))
    def K = new Box(new Leaf(KComb))
    
    sealed trait Completion {
        def successor(f: Formula): Completion
        val name: String
        val actionable: Boolean
    }
    case object CompletionUnknown extends Completion {
        def successor(f: Formula) = CompletionUnknown
        val name = "?"
        val actionable = false
    }
    case class CS(s: Leaf) extends Completion {
        def successor(f: Formula) = CS1(s, f)
        val name = "s"
        val actionable = false
    }
    case class CS1(s: Leaf, a: Formula) extends Completion {
        def successor(f: Formula) = CS2(s, a, f)
        val name = "s1"
        val actionable = false
    }
    case class CS2(s: Leaf, a: Formula, b: Formula) extends Completion {
        def successor(f: Formula) = CS3(s, a, b, f)
        val name = "s2"
        val actionable = false
    }
    case class CS3(s: Leaf, a: Formula, b: Formula, c: Formula) extends Completion {
        def successor(f: Formula) = CompletionUnknown
        val name = "s3"
        val actionable = true
    }
    case class CK(k: Leaf) extends Completion {
        def successor(f: Formula) = CK1(k, f)
        val name = "k"
        val actionable = false
    }
    case class CK1(k: Leaf, a: Formula) extends Completion {
        def successor(f: Formula) = CK2(k, a, f)
        val name = "k1"
        val actionable = false
    }
    case class CK2(k: Leaf, a: Formula, b: Formula) extends Completion {
        def successor(f: Formula) = CompletionUnknown
        val name = "k2"
        val actionable = true
    }
    
    // Node types
    val LEAF_TYPE = 0
    val PAIR_TYPE = 1
}

