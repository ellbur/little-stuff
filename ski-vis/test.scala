
// See
// http://prefuse.org/doc/manual/introduction/example/

import javax.swing._

import prefuse._
import prefuse.action._
import prefuse.action.assignment._
import prefuse.activity._
import prefuse.controls._
import prefuse.data._
import prefuse.data.io._
import prefuse.render._
import prefuse.util._
import prefuse.visual._
import prefuse.action.layout.graph._
import scala.util.Random
import java.awt.event._

object test {
//

def run() {
    val nodeTable = new Table
    nodeTable.addColumn("label", classOf[String])
    nodeTable.addColumn("type", classOf[Int])
    
    val edgeTable = new Table(0, 1)
    edgeTable.addColumn(Graph.DEFAULT_SOURCE_KEY, classOf[Int])
    edgeTable.addColumn(Graph.DEFAULT_TARGET_KEY, classOf[Int])
    edgeTable.addColumn("label", classOf[String])
    
    val graph = new Graph(nodeTable, edgeTable, true)
    val a = graph.addNode; a.setString("label", "A"); a.setInt("type", 0)
    val b = graph.addNode; b.setString("label", "B"); b.setInt("type", 0)
    val c = graph.addNode; c.setString("label", "C"); c.setInt("type", 1)
    
    val ab = graph.addEdge(a, b); ab.setString("label", "ab")
    val bc = graph.addEdge(b, c); ab.setString("label", "bc")
    
    val vis = new Visualization
    vis.add("graph", graph)
    vis.setInteractive("graph.edges", null, false)
    
    val labRend = new LabelRenderer("label")
    labRend.setRoundedCorner(8, 8)
    vis.setRendererFactory(new DefaultRendererFactory(labRend))
    
    val palette = Array[Int](
        ColorLib.rgb(255, 255, 180),
        ColorLib.rgb(190, 255, 180)
    )
    
    val fill  = new DataColorAction("graph.nodes", "type", Constants.NOMINAL, VisualItem.FILLCOLOR, palette)
    
    val text  = new ColorAction("graph.nodes", VisualItem.TEXTCOLOR,   ColorLib.gray(0))
    val edges = new ColorAction("graph.edges", VisualItem.STROKECOLOR, ColorLib.gray(200))
    
    val color = new ActionList
    color.add(fill)
    color.add(text)
    color.add(edges)
    vis.putAction("color", color)
    
    val layout = new ActionList(Activity.INFINITY)
    layout.add(new ForceDirectedLayout("graph"))
    layout.add(new RepaintAction())
    vis.putAction("layout", layout)
    
    val repaint = new ActionList
    repaint.add(new RepaintAction)
    vis.putAction("repaint", repaint)
    
    val disp = new Display(vis)
    disp.setSize(720, 500)
    disp.addControlListener(new DragControl)
    disp.addControlListener(new PanControl)
    disp.addControlListener(new ZoomControl)
    
    val win = new JFrame("Prefuse from Scala")
    win.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE)
    win.add(disp)
    win.pack
    win.setVisible(true)
    
    vis.run("color")
    vis.run("layout")
    
    // Set the timer that will add nodes!!
    var lastNode: Node = c
    val timer = new Timer(2000, new ActionListener {
        def actionPerformed(e: ActionEvent) {
            print("Adding... ")
            
            val nextNode = graph.addNode
            nextNode.setString("label", "x")
            nextNode.setInt("type", Random nextInt 2)
            
            val nextEdge = graph.addEdge(lastNode, nextNode)
            nextEdge.setString("label", "x")
            
            lastNode = nextNode
            
            vis.run("repaint")
            vis.run("color")
            
            println("Done.")
        }
    })
    timer.setRepeats(true)
    timer.start
}

def main(args: Array[String]) {
    SwingUtilities invokeLater (new Runnable {
        def run() { test.run }
    })
}

//
}

