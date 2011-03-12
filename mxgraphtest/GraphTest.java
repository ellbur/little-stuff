
import java.util.*;
import java.lang.reflect.*;

import com.mxgraph.view.*;
import com.mxgraph.swing.*;
import com.mxgraph.layout.*;
import com.mxgraph.layout.hierarchical.*;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.event.*;

public class GraphTest {
	
	public static void main(String[] args) {
		
		mxGraph graph = new mxGraph();
		Object parent = graph.getDefaultParent();
		
		graph.getModel().beginUpdate();
		
		Object o1 = graph.insertVertex(
			parent, null, "1", 100, 100, 30, 30
		);
		Object o2 = graph.insertVertex(
			parent, null, "2", 0, 0, 30, 30
		);
		Object o3 = graph.insertVertex(
			parent, null, "3", 200,  80, 30, 30
		);
		
		Object e12 = graph.insertEdge(
			parent, null, "e12", o1, o2
		);
		Object e23 = graph.insertEdge(
			parent, null, "e23", o2, o3
		);
		
		mxHierarchicalLayout layout = new mxHierarchicalLayout(graph);
		layout.setFixRoots(true);
		layout.execute(parent, new Object[] {o3, o1});
		
		graph.getModel().endUpdate();
		
		JFrame window = new JFrame("mxGraph Test");
		window.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		Container cp = window.getContentPane();
		
		cp.add(new mxGraphComponent(graph));
		
		window.pack();
		window.setVisible(true);
	}
	
}
