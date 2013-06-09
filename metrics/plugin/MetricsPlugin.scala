
package metrics

import scala.tools.nsc.{ast, plugins, symtab, util, Global, Phase}
import ast.parser.Tokens
import plugins.{Plugin,PluginComponent}
import symtab.Flags
import util.SourceFile

class MetricsPlugin(val global: Global)
    extends Plugin with MetricsRunner
{
    plugin =>
    
    val name = "metrics"
    val description = "stuff"
    val components = List[PluginComponent](component)
    
    lazy val component = new PluginComponent {
        val global = plugin.global
        val phaseName = "metrics"
        
        def newPhase(prev: Phase) = new MetricsPhase(prev)
        
        val runsAfter = "liftcode" :: Nil
        //override val runsBefore = "superaccessors" :: Nil
    }
    
    class MetricsPhase(prev: Phase) extends Phase(prev) {
        def name = "metrics"
        def run { 
            doMetrics
        }
    }
}

