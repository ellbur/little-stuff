
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
import java.awt._

object test2 {
//

def run() {
    val nodeTable = new Table
    nodeTable.addColumn("label", classOf[String])
    nodeTable.addColumn("type", classOf[Int])
    nodeTable.addColumn("car", classOf[Boolean])
    nodeTable.addColumn("state", classOf[Int])
    
    val edgeTable = new Table(0, 1)
    edgeTable.addColumn(Graph.DEFAULT_SOURCE_KEY, classOf[Int])
    edgeTable.addColumn(Graph.DEFAULT_TARGET_KEY, classOf[Int])
    edgeTable.addColumn("type", classOf[Int])
    edgeTable.addColumn("car", classOf[Boolean])
    
    val graph = new Graph(nodeTable, edgeTable, true)
    
    val vis = new Visualization
    vis.add("graph", graph)
    vis.setInteractive("graph.edges", null, false)
    
    //---------------------
    val _graph = graph // Is there a better way to do this?
    val ski = new SKI {
        val graph = _graph
        val visualization = vis
    }
    
    import ski.{S,K}
    val formula = S(K)(S(S(K(K)(K))(K(S))(S(S)(S))))
    // --------------------
    
    val labRend = new LabelRenderer("label")
    labRend.setRoundedCorner(8, 8)
    val edgeRend1 = new EdgeRenderer(Constants.EDGE_TYPE_LINE, Constants.EDGE_ARROW_FORWARD)
    edgeRend1.setArrowHeadSize(4, 4)
    val edgeRend2 = new EdgeRenderer(Constants.EDGE_TYPE_LINE, Constants.EDGE_ARROW_FORWARD)
    edgeRend2.setArrowHeadSize(10, 10)
    val rendFact = new DefaultRendererFactory(labRend, edgeRend1)
    rendFact.add("[car]", edgeRend2)
    vis.setRendererFactory(rendFact)
    
    val palette = Array[Int](
        ColorLib.rgb(255, 255, 180),
        ColorLib.rgb(190, 255, 180)
    )
    val strokePalette = Array[Int](
        ColorLib.rgb(255, 255, 255),
        ColorLib.rgb(  0,   0,   0),
        ColorLib.rgb(255,   0,   0),
        ColorLib.rgb(  0, 255,   0)
    )
    val edgePalette = Array[Int](
        ColorLib.rgb(0, 0, 0),
        ColorLib.rgb(180, 180, 180)
    )
    
    val fill   = new DataColorAction("graph.nodes", "type", Constants.ORDINAL, VisualItem.FILLCOLOR, palette)
    val stroke = new StrokeAction("graph.nodes", new BasicStroke(2))
    val strokeColor = new DataColorAction("graph.nodes", "state", Constants.NOMINAL,
        VisualItem.STROKECOLOR, strokePalette)
    strokeColor.setBinCount(strokePalette.length)
    strokeColor.setOrdinalMap(0 to strokePalette.length map (new java.lang.Integer(_)) toArray)
    
    val text  = new ColorAction("graph.nodes", VisualItem.TEXTCOLOR,   ColorLib.gray(0))
    val edges = new DataColorAction("graph.edges", "type", Constants.NOMINAL, VisualItem.STROKECOLOR, edgePalette)
    val heads = new DataColorAction("graph.edges", "type", Constants.NOMINAL, VisualItem.FILLCOLOR, edgePalette)
    
    val color = new ActionList
    color.add(fill)
    color.add(stroke)
    color.add(strokeColor)
    color.add(text)
    color.add(edges)
    color.add(heads)
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
    disp.addControlListener(ski.hoverListener)
    
    val win = new JFrame("Prefuse from Scala")
    win.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE)
    win.add(disp)
    win.pack
    win.setVisible(true)
    
    vis.run("color")
    vis.run("layout")
    
}

def main(args: Array[String]) {
    SwingUtilities invokeLater (new Runnable {
        def run() { test2.run }
    })
}

//
}

