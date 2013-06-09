
package smacro

import scala.tools.nsc
import nsc.Global
import nsc.Phase
import nsc.plugins.Plugin
import nsc.plugins.PluginComponent
import nsc.transform.Transform
import nsc.symtab.Flags
import nsc.ast.TreeDSL

import scalaz._
import scalaz.Scalaz._

class MacroPlugin(val global: Global) extends Plugin {
    plugin =>
    
    val name = "smacro"
    val description = "Macros for Scala"
    val components = List[PluginComponent](component)
    
    lazy val component = new PluginComponent with Transform {
        component =>
        
        val global = plugin.global
        import global._
        
        val phaseName = "macros"
        
        def newTransformer(unit: CompilationUnit) = new MacroTransformer
        val runsAfter = "parser" :: Nil
        
        class MacroTransformer extends Transformer with TransformTest {
            type GType = component.global.type
            val global: GType = component.global
            
            def fallback(tree: Tree) = super.transform(tree)
            override def transform(tree: Tree) = process(tree)
        }
    }
}
object MacroPlugin {
    def main(args: Array[String]) {
        val plugin = new MacroPlugin(null)
        println(plugin.name)
        println(plugin.description)
        println(plugin.components)
    }
}

trait TransformTest extends TreeDSL {
    outer =>
    
    type GType <: Global
    val global: GType
    
    import global._
    import CODE._
    
    def fallback(tree: Tree): Tree
    
    def process(tree: Tree): Tree = tree match {
        case ap: Apply => processApply(ap)
        case _ => fallback(tree)
    }
    
    def processApply(ap: Apply): Tree = ap.fun match {
        case id: Ident if id.name startsWith "$" =>
            processMacroBranch(id.name.toString, ap.args)
            
        case _ => fallback(ap)
    }
    
    def processMacroBranch(key: String, args: List[Tree]): Tree = {
        val ca = new CountApplies {
            type GType = outer.global.type
            val global: GType = outer.global
        }
        val total = args map (ca traverse (_)) map (_.x) sum
        
        LIT(total)
    }
}

case class Count[+A](x: Int)

trait CountApplies extends NiceTraverser {
    type GType <: Global
    val global: GType
    
    import global._
    
    type Result[+A] = Count[A]
    implicit val applicative = new Applicative[Result] {
        def pure[A](a: => A) = Count[A](0)
        override def apply[A,B](f: Result[A => B], x: Result[A]) = Count[B](f.x + x.x)
    }
    
    def traverse(tree: Tree) = tree match {
        case x: Apply => Count(fallback(x).x + 1)
        case other    => fallback(other)
    }
}

trait MacroTransform extends TreeDSL {
    type GType <: Global
    val global: GType
    
    import global._
    import CODE._
    
    def fallback(tree: Tree): Tree
    
    /*
    val macroDefinitions = List(
        MacroDefinition(
            LHSMacroLike("rs",
                LHSCodeLike("f",
                    LHSMacroLike("sh",
                        LHSCodeLike("g", Nil)::Nil)::Nil)::Nil),
            '$rs APP ('g APP 'f)
        ),
        MacroDefinition(
            LHSMacroLike("rs", LHSCodeLike("x", Nil)),
            'x
        )
    )
    */
   val macroDefinitions = List[MacroDefinition]()
    
    def process(tree: Tree): Tree = tree match {
        case ap: Apply => processApply(ap)
        case id: Ident => processIdent(id)
        case _ => fallback(tree)
    }
    
    // Can't really do this yet
    def processIdent(id: Ident): Tree =
        if (id.name startsWith "$") LIT(7)
        else fallback(id)
    
    def processApply(ap: Apply): Tree = ap.fun match {
        case id: Ident if id.name startsWith "$" =>
            processMacroBranch(id.name.toString, ap.args)
            
        case _ => fallback(ap)
    }
    
    def processMacroBranch(key: String, args: List[Tree]): Tree = {
        val test = buildTestMacro(key, args)
        
        /*
        macroDefinitions firstSome { case MacroDefinition(lhs, rhs) =>
            lhs bind test map { bindings =>
                rhs applyBindings bindings
            }
        }
        */
       sys.error("Not implemented")
    }

    def buildTestMacro(key: String, args: List[Tree]) =
        TestMacroLike(key, args map buildTestCode _)
    
    def buildTestCode(tree: Tree) = sys.error("no")

    case class LHSMacroLike(name: String, args: List[LHSCodeLike])
        extends LHSMacroLikeOps
    case class LHSCodeLike(name: String, args: List[LHSMacroLike])
        extends LHSCodeLikeOps

    case class MacroDefinition(lhs: LHSMacroLike, rhs: Tree)

    case class TestMacroLike(name: String, args: List[TestCodeLike])
    case class TestCodeLike(code: Tree, args: List[TestMacroLike])

    trait LHSMacroLikeOps {
        this: LHSMacroLike =>
        
        def bind(test: TestMacroLike): Option[List[(String,Tree)]] =
            if (name != test.name) None
            else if (args.length != test.args.length) None
            else (args zip test.args map { case (lhs, test) =>
                lhs bind test
            }).sequence map (_.flatten)
    }

    trait LHSCodeLikeOps {
        this: LHSCodeLike =>
        
        def bind(test: TestCodeLike): Option[List[(String,Tree)]] =
            if (args.length != test.args.length) None
            else (args zip test.args map { case (lhs, test) =>
                lhs bind test
            }).sequence map ((name, test.code) :: _.flatten)
    }
}

