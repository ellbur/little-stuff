
package metrics

import scala.tools.nsc.{ast, plugins, symtab, util, Global}
import ast.parser.Tokens
import plugins.Plugin
import symtab.Flags
import util.SourceFile
import java.io._
import scala.math.{min}

trait MetricsRunner {
    this: MetricsPlugin =>
    
    def doMetrics() {
        val metrics = new Metrics(global)
        val summary = metrics.summary(metrics.global.currentRun.units)
        val stats = metrics.aggregateStats(summary)
        
        metrics.printMetrics(summary, stats)
        metrics.graphviz(summary, stats)
    }
}
class Metrics(val global: Global) {
    import global._
    
    def printMetrics(summary: Summary, stats: AggregateStats) {
        val out = new PrintWriter(new FileWriter("./metrics-summary.txt"))
        val csv = new PrintWriter(new FileWriter("./metrics.csv"))
        import out.{print,println}
        
        csv.println("id,name,SCOM,CC,LSCC,CAMC")
        
        summary.classes foreach { cl =>
            val methods = stats.classMethods(cl)
            val vars    = stats.classVars(cl)
            val pairs   = stats.methodPairs(cl)
            val numVars = vars.size
            
            val CC = {
                val parts = pairs map { case (meth1, meth2) =>
                    val vars1 = stats.methodVars(meth1)
                    val vars2 = stats.methodVars(meth2)
                    
                    if (vars1.isEmpty || vars2.isEmpty) 0
                    else (
                          ((vars1 & vars2).size: Double)
                        / ((vars1 ++ vars2).size: Double)
                    )
                }
                
                if (pairs.length == 0) 1.0
                else if (numVars == 0) 0.0
                else 1.0/(pairs.length: Double) * parts.sum
            }
            
            val SCOM = {
                val parts = pairs map { case (meth1, meth2) =>
                    val vars1 = stats.methodVars(meth1)
                    val vars2 = stats.methodVars(meth2)
                    
                    if (vars1.isEmpty || vars2.isEmpty) 0
                    else {
                        val c = (
                              ((vars1 & vars2).size: Double)
                            / (min(vars1.size, vars2.size): Double)
                        )
                        val weight = (
                              ((vars1 ++ vars2).size: Double)
                            / (numVars: Double)
                        )
                        
                        c * weight
                    }
                }
            
                if (pairs.length == 0) 1.0
                else if (numVars == 0) 0.0
                else 1.0/(pairs.length: Double) * parts.sum
            }
            
            val LSCC = {
                if (methods.size==0) 1.0
                else if (vars.size==0) 0.0
                else if (methods.size==1) 1.0
                else {
                    val num = (vars.toList map (stats.varMethods(_).size) map (x => x*(x-1))).sum
                    val den = vars.size * methods.size * (methods.size - 1)
                    
                    (num: Double) / den
                }
            }
            
            val CAMC = {
                val paramTypeSets: List[Set[Type]] = methods.toList map { method =>
                    Set(method.tree.vparamss flatMap (_ map (_.tpt.tpe)):  _*)
                }
                val allParamTypes: Set[Type] = Set(paramTypeSets flatMap identity: _*)
                
                val a = (paramTypeSets map (_.size)).sum
                val k = methods.size
                val l = allParamTypes.size
                
                if (k==0 || l==0) 1.0
                else (a: Double) / (k*l)
            }
            
            def short(s: String) =
                if (s.length > 7) s.substring(0, 7)
                else s
            
            println(cl.tree)
            println("%s: SCOM=%.3f CC=%.3f LSCC=%.3f CAMC=%.3f" format (cl.name, SCOM, CC, LSCC, CAMC))
            
            print("        ")
            methods foreach { method => print("%8s" format (short(method.name))) }
            println()
            vars foreach { v =>
                print("%8s" format (short(v.name)))
                methods foreach { method =>
                    print("%8s" format {
                        if (stats.methodVars(method)(v)) "  X  "
                        else " "
                    })
                }
                println()
            }
            println()
            
            csv.println("%d,%s,%.3f,%.3f,%.3f,%.3f" format (
                cl.symbol.id, cl.name, SCOM, CC, LSCC, CAMC
            ))
        }
        
        out.flush()
        out.close()
        csv.flush()
        csv.close()
    }
    
    case class AggregateStats(
            classVars:    Map[Class, Set[Var]],
            classMethods: Map[Class, Set[Method]],
            methodVars:   Map[Method, Set[Var]],
            varMethods:   Map[Var, Set[Method]],
            methodPairs:  Map[Class, Seq[(Method,Method)]]
        )
    
    def aggregateStats(summary: Summary): AggregateStats = {
        val classVars = summary.vars.groupFull(summary.classes)(_.context.name)
        val classMethods = summary.methods.groupFull(summary.classes)(_.context.name)
        
        val refs = summary.indirectVarRefs
        val methodVars = refs.groupFull(summary.methods)(_.from) mapValues (_ map (_.to))
        val varMethods = refs.groupFull(summary.vars)(_.to) mapValues (_ map (_.from))
        
        val methodPairs = classMethods mapValues { methods =>
            methods.toList combinations 2 map { case Seq(m1, m2) => (m1, m2) } toList
        }
        
        AggregateStats(
            classVars    = classVars,
            classMethods = classMethods,
            methodVars   = methodVars,
            varMethods   = varMethods,
            methodPairs  = methodPairs
        )
    }
    
    def graphviz(summary: Summary, stats: AggregateStats) {
        val out = new PrintWriter(new FileWriter("./metrics.dot"))
        
        out.println("digraph metrics {")
        summary.classes foreach { cl =>
            out.println("subgraph cluster%s {" format cl.id)
            out.println("label = \"%s\"" format cl.name)
            stats.classVars(cl) foreach { v =>
                out.println("v%s [shape=circle,label=\"%s\"];" format (
                    v.symbol.id, v.symbol.name
                ))
            }
            stats.classMethods(cl) foreach { m =>
                out.println("m%s [shape=box,label=\"%s()\"];" format (
                    m.symbol.id, m.symbol.name
                ))
            }
            out.println("}")
        }
        (summary.indirectVarRefs ++ summary.ghostRefs) foreach {
            case VarRef(from, to) =>
                out.println("m%s -> v%s;" format (from.id, to.id))
        }
        summary.methodRefs foreach { case MethodRef(from, to) =>
            out.println("m%s -> m%s;" format (from.id, to.id))
        }
        out.println("}")
        out.flush()
        out.close()
    }
    
    final class GroupFull[A](s: Set[A]) {
        def groupFull[K](keys: TraversableOnce[K])(keyer: A => K) = {
            val partial = s groupBy keyer
            val full = Map(keys map { key => key -> Set[A]() } toList: _*) ++ partial
            full
        }
    }
    implicit def toGroupFull[A](s: Set[A]): GroupFull[A] = new GroupFull(s)
    
    def summary(units: TraversableOnce[CompilationUnit]) = {
        val stage1s = currentRun.units map { unit =>
            traverseRefs(unit.body, Nowhere)
        }
        val stage1 = stage1s.foldLeft(Stage1.empty)(_ ++ _)
        collectRefs(stage1)
    }
    
    case class Summary(
            classes:         Set[Class],
            vars:            Set[Var],
            methods:         Set[Method],
            indirectVarRefs: Set[VarRef],
            methodRefs:      Set[MethodRef],
            ghostRefs:       Set[VarRef]
        )
    {
        def print() {
            def dump(title: String, xs: Iterable[AnyRef]) {
                println(title + ":")
                xs foreach (x => println("  " + x))
            }
            
            dump("Classes", classes)
            dump("Methods", methods)
            dump("Vars", vars)
            dump("Indirect Var Refs", indirectVarRefs)
            dump("Method Refs", methodRefs)
        }
    }
    
    case class VarRef(from: Method, to: Var)
    case class MethodRef(from: Method, to: Method)
    
    def collectRefs(stage1: Stage1): Summary = {
        val classes = Set(stage1.classes: _*)
        val classMap = Map(stage1.classes map (c => c.symbol -> c): _*)
        val methods = Map(stage1.methods map (m => m.symbol -> m): _*)
        val vars    = Map(stage1.vars map (v => v.symbol -> v): _*)
        
        val unapplyRefs = Set({
            for {
                Unapply(im, clsSym) <- stage1.unapplies
                cls <- (classMap get clsSym).toList
                field <- stage1.caseFields
                if (field.ofClass.symbol == clsSym)
                to <- methods get field.field
                from <- methods get im.methodName
            }
            yield MethodRef(from, to)
        }: _*)
        
        val allDirectVarRefs = Set ({
            for {
                ref <- stage1.refs
                from <- methods get ref.context.methodName
                to <- vars get ref.symbol
            }
            yield VarRef(from, to)
        }: _*)
        
        val (localDirectVarRefs, globalDirectVarRefs) = allDirectVarRefs partition {
            case VarRef(from, to) => from.context == to.context
        }
        val directVarRefs = localDirectVarRefs
        
        val primMethodRefs = Set({
            for {
                ref <- stage1.refs
                from <- methods get ref.context.methodName
                to <- methods get ref.symbol
            }
            yield MethodRef(from, to)
        }: _*)
        val methodRefs = primMethodRefs ++ unapplyRefs
        
        val localMethodRefs = methodRefs filter { methodRef =>
            methods(methodRef.from.symbol).context == methods(methodRef.to.symbol).context
        }
        
        def propagateRefs(varRefs: Set[VarRef]): Set[VarRef] = {
            val nextVarRefs = varRefs ++ {
                for {
                    varRef    <- varRefs
                    methodRef <- localMethodRefs
                    if (methodRef.to == varRef.from)
                }
                yield VarRef(methodRef.from, varRef.to)
            }
            
            if (nextVarRefs == varRefs) varRefs
            else propagateRefs(nextVarRefs)
        }
        val indirectVarRefs = propagateRefs(directVarRefs)
        
        val interestingClasses = classes filter { cls =>
            cls.tree match {
                case cd: ClassDef => !cd.mods.isSynthetic
                case md: ModuleDef => !md.mods.isSynthetic
                case _ => true
            }
        }
        
        val (interesting, boring) = Set(methods.values.toList: _*) partition { meth =>
            val dd = meth.tree
            (
                   interestingClasses(meth.context.name)
                && (!dd.mods.isSynthetic) && (!dd.mods.hasAccessorFlag)
                && (dd.name.toString != "toString")
                && (dd.name.toString != "equals")
                && (dd.name.toString != "hashCode")
                && (dd.name.toString != "productPrefix")
                && (dd.name.toString != "productElement")
                && (dd.name.toString != "canEqual")
                && (dd.name.toString != "productArity")
            )
        }
        val interestingMethods = interesting
        
        val lostRefs = methodRefs filter ( ref =>
            boring(ref.to) && interesting(ref.from)
        )
        val ghostRefs = lostRefs flatMap { ref =>
            indirectVarRefs filter (vref => vref.from == ref.to) map { vref =>
                VarRef(ref.from, vref.to)
            }
        }
        
        val varSet = Set(vars.values.toList: _*)
        val realIndirectVarRefs = indirectVarRefs filter { ref =>
            interestingMethods(ref.from) && varSet(ref.to)
        }
        
        val realMethodRefs = methodRefs filter { ref =>
            interestingMethods(ref.from) && interestingMethods(ref.to)
        }
        
        Summary(
            classes         = interestingClasses,
            methods         = interestingMethods,
            vars            = varSet,
            indirectVarRefs = realIndirectVarRefs,
            methodRefs      = realMethodRefs,
            ghostRefs       = ghostRefs ++ globalDirectVarRefs
        )
    }
    
    case class IdSym(symbol: Symbol) {
        override def toString = "%s(%d)" format (symbol, symbol.id)
    }
    object IdSym {
        implicit def extract(idsym: IdSym): Symbol = idsym.symbol
    }
    implicit def idSym(symbol: Symbol): IdSym = IdSym(symbol)
    
    sealed trait Context
    case object Nowhere extends Context
    case class InClass(name: Class) extends Context
    case class InMethod(className: Class, methodName: IdSym) extends Context
    
    case class Class(name: String, id: Int, tree: Tree, symbol: IdSym)
    case class Var(context: InClass, symbol: IdSym, tree: Tree) {
        def id = symbol.id
        def name = symbol.name.toString.trim
    }
    case class Method(context: InClass, symbol: IdSym, tree: DefDef) {
        def id = symbol.id
        def name = symbol.name.toString.trim
    }
    case class Ref(context: InMethod, symbol: IdSym)
    case class CaseField(ofClass: Class, field: IdSym)
    case class Unapply(context: InMethod, ofClass: IdSym)
    
    case class Stage1(
            classes:    List[Class],
            vars:       List[Var],
            methods:    List[Method],
            refs:       List[Ref],
            caseFields: List[CaseField],
            unapplies:  List[Unapply]
        )
    {
        def ++(other: Stage1) = Stage1(
            classes = this.classes ++ other.classes,
            vars    = this.vars    ++ other.vars,
            methods = this.methods ++ other.methods,
            refs    = this.refs    ++ other.refs,
            caseFields = this.caseFields ++ other.caseFields,
            unapplies = this.unapplies ++ other.unapplies
        )
    }
    object Stage1 {
        def empty = Stage1(Nil, Nil, Nil, Nil, Nil, Nil)
    }
    
    def traverseRefs(tree: Tree, context: Context): Stage1 = {
        val newUnapplies = context match {
            case im: InMethod =>
                tree match {
                    case ap: Apply =>
                        import scala.tools.nsc.symtab._
                        ap.fun match {
                            case tt: TypeTree =>
                                tt.tpe match {
                                    case mt: MethodType =>
                                        Unapply(im, mt.resultType.typeSymbol) :: Nil
                                    case _ => Nil
                                }
                            case _ => Nil
                        }
                    case _ => Nil
                }
            case _ => Nil
        }
        
        val newClasses = tree match {
            case cd: ClassDef => Class(cd.name.toString, cd.id, cd, cd.symbol) :: Nil
            case md: ModuleDef => Class(md.name.toString, md.id, md, md.symbol) :: Nil
            case _ => Nil
        }
        
        val newContext = newClasses match {
            case cl :: _ => InClass(cl)
            case _ =>
                tree match {
                    case dd: DefDef if (dd.hasSymbol) =>
                        context match {
                            case InClass(className) => InMethod(className, dd.symbol)
                            case _ => context
                        }
                    case _ => context
                }
        }
        
        // We only care about vars in a class
        val newVars = context match {
            case ic: InClass =>
                tree match {
                    case vd: ValDef if (
                               (vd.mods.isParamAccessor && !vd.mods.hasAccessorFlag)
                            || vd.mods.isMutable || vd.mods.hasAbstractFlag) =>
                        if (vd.hasSymbol) Var(ic, vd.symbol, tree) :: Nil
                        else Nil
                    case dd: DefDef if (dd.hasSymbol && dd.rhs==EmptyTree) =>
                        Var(ic, dd.symbol, dd) :: Nil
                    case _ => Nil
                }
            case _ => Nil
        }
        
        val newCaseFields = newClasses flatMap { cl =>
            cl.tree.symbol.caseFieldAccessors map { sym =>
                CaseField(cl, sym)
            }
        }
        
        // We only care about methods in a class
        val newMethods = context match {
            case ic: InClass =>
                tree match {
                    case dd: DefDef if (dd.hasSymbol && !dd.symbol.isConstructor
                            && dd.rhs!=EmptyTree) =>
                        Method(ic, dd.symbol, dd) :: Nil
                    case _ => Nil
                }
            case _ => Nil
        }
        
        // We only care about refs in a method
        val newRefs = context match {
            case im: InMethod =>
                tree match {
                    case s: Select if (s.hasSymbol) => Ref(im, s.symbol) :: Nil
                    case _ => Nil
                }
            case _ => Nil
        }
        
        val next = tree.children map (traverseRefs(_, newContext))
        Stage1(
            classes = newClasses ++ (next flatMap (_.classes)),
            vars    = newVars    ++ (next flatMap (_.vars)),
            methods = newMethods ++ (next flatMap (_.methods)),
            refs    = newRefs    ++ (next flatMap (_.refs)),
            caseFields = newCaseFields ++ (next flatMap (_.caseFields)),
            unapplies = newUnapplies ++ (next flatMap (_.unapplies))
        )
    }
    
    // --------------------------------------------------------------
    // For printing out all nodes
    
    def traversePrint(tree: Tree) {
        val sym =
            if (tree.hasSymbol) " (%s %d)" format (tree.symbol, tree.symbol.id)
            else ""
            
        println(tree.getClass.getName + sym)
        println(tree)
        println()
        
        tree.children foreach traversePrint _
    }
}

