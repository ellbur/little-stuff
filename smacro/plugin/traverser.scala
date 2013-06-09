
package smacro

import scalaz._
import scalaz.Scalaz._

import scala.tools.nsc
import nsc.Global

// Copied from http://harrah.github.com/browse/samples/compiler/scala/tools/nsc/ast/Trees.scala.html#26932

trait NiceTraverser {
    type Result[+A]
    implicit val applicative: Applicative[Result]
    
    type GType <: Global
    val global: GType
    
    import global._
    
    def traverse(tree: Tree): Result[Tree]
    
    def fallback(tree: Tree): Result[Tree] = tree match {
        case x @ EmptyTree => x.pure
            /*
        case x @ PackageDef(pid, stats) =>
            val cons = { (pid: RefTree) => (stats: List[Tree]) =>
                treeCopy.PackageDef(x, pid, atOwner(tree.symbol.moduleClass)(stats))
            }
            (traverseRef(pid) |@| (stats map traverse _ sequence)) (cons)
        case x @ ClassDef(mods, name, tparams, impl) =>
            val cons = { (mods: Modifiers) => (tparams: List[TypeDef]) => (impl: Template) =>
                atOwner(tree.symbol) {
                    treeCopy.ClassDef(x, mods, name, tparams, impl)
                }
            }
            cons <$> traverseMods(mods) <*> (tparams map traverseTypeDef _ sequence) <*> traverseTemplate(impl)
        case x @ ModuleDef(mods, name, impl) =>
            val cons = { (mods: Modifiers) => (impl: Template) =>
                atOwner(tree.symbol.moduleClass) {
                    treeCopy.ModuleDef(x, mods, name, impl)
                }
            }
            cons <$> traverseMods(mods) <*> traverseTemplate(impl)
        case x @ ValDef(mods, name, tpt, rhs) =>
            val cons = { (mods: Modifiers) => (tpt: Tree) => (rhs: Tree) =>
                atOwner(tree.symbol) {
                    treeCopy.ValDef(x, mods, name, tpt, rhs)
                }
            }
            cons <$> traverseMods(mods) <*> traverse(tpt) <*> traverse(rhs)
        case x @ DefDef(mods, name, tparams, vparamss, tpt, rhs) =>
            val cons = { (mods: Modifiers) => (tparams: List[TypeDef]) =>
                    (vparamss: List[List[ValDef]]) => (tpt: Tree) => (rhs: Tree)
                atOwner(tree.symbol) {
                    treeCopy.DefDef(x, mods, name, tparams, vparamss,
                        tpt, rhs)
                }
            }
            (cons <$> traverseMods(mods) <*> (tparams map traverseTypeDef _ sequence) <*>
                (vparamss map (_ map traverseValDef sequence _) sequence) <*> traverse(tpt) <*> traverse(rhs))
        case x @ TypeDef(mods, name, tparams, rhs) =>
            val cons = { (mods: Modifiers) => (tparams: List[TypeDef]) => (rhs: Tree) =>
                atOwner(tree.symbol) {
                    treeCopy.TypeDef(x, mods, name, tparams, rhs)
                }
            }
            (cons <$> traverseMods(mods) <*> (tparams map traverseTypeDef _ sequence) <*>
                traverse(rhs))
        case x @ LabelDef(name, params, rhs) =>
            val cons = { (params: List[Ident]) => (rhs: Tree) =>
                treeCopy.LabelDef(x, name, params, rhs)
            }
            cons <$> (params map traverseIdent _) <*> traverse(rhs)
        case x @ Import(expr, selectors) =>
            val cons = { (expr: Tree) =>
                treeCopy.Import(x, expr, selectors)
            }
            cons <$> traverse(expr)
        case x @ DocDef(comment, definition) =>
            val cons = { (definition: Tree) =>
                treeCopy.DocDef(x, comment, definition)
            }
            cons <$> traverse(definition)
        case x @ Template(parents, self, body) =>
            val cons = { (parents: List[Tree]) => (self: ValDef) => (body: List[Tree]) =>
                treeCopy.Template(x, parents, self, body)
            }
            cons <$> (parents map traverse _ sequence) <*> traverseValDef(self) <*> (body map traverse _ sequence)
        case x @ Block(stats, expr) =>
            val cons = { (stats: List[Tree]) => (expr: Tree) =>
                treeCopy.Block(x, stats, expr)
            }
            cons <$> (stats map traverse _ sequence) <*> traverse(expr)
        case x @ CaseDef(pat, guard, body) =>
            val cons = { (pat: Tree) => (guard: Tree) => (body: Tree) =>
                treeCopy.CaseDef(x, pat, guard, body)
            }
            cons <$> traverse(pat) <*> traverse(guard) <*> traverse(body)
        case x @ Sequence(trees) =>
            val cons = { (trees: List[Tree]) =>
                treeCopy.Sequence(x, trees)
            }
            cons <$> (trees map traverse _ sequence)
        case x @ Altenative(trees) =>
            val cons = { (trees: List[Tree]) =>
                treeCopy.Alternative(x, trees)
            }
            cons <$> (trees map traverse _ sequence)
        case x @ Star(elem) =>
            val cons = { (elem: Tree) =>
                treeCopy.Star(x, elem)
            }
            cons <$> traverse(elem)
        case x @ Bind(name, body) =>
            val cons = { (body: Tree) =>
                treeCopy.Bind(x, name, body)
            }
            cons <$> traverse(body)
        case x @ UnApply(fun, args) =>
            val cons = { (args: List[Tree]) =>
                treeCopy.UnApply(x, fun, args)
            }
            cons <$> (args map traverse _ sequence)
        case x @ ArrayValue(elemtpt, trees) =>
            val cons = { (elemtpt: Tree) => (trees: List[Tree]) =>
                treeCopy.ArrayValue(x, elemtpt, trees)
            }
            cons <$> traverse(elemtpt) <*> (trees map traverse _ sequence)
        case x @ Function(vparams, body) =>
            val cons = { (vparams: List[ValDef]) => (body: Tree) =>
                treeCopy.Function(tree, vparams, body)
            }
            cons <$> (vparams map traverseValDef _ sequence) <*> traverse(body)
        case x @ Assign(lhs, rhs) =>
            val cons = { (lhs: Tree) => (rhs: Tree) =>
                treeCopy.Assign(x, lhs, rhs)
            }
            cons <$> traverse(lhs) <*> traverse(rhs)
        case x @ AssignOrNamedArg(rhs, rhs) =>
            val cons = { (lhs: Tree) => (rhs: Tree) =>
                treeCopy.AssignOrNamedArg(x, lhs, rhs)
            }
            cons <$> traverse(lhs) <*> traverse(rhs)
        case x @ If(cond, thenp, elsep) =>
            val cons = { (cond: Tree) => (thenp: Tree) => (elsep: Tree) =>
                treeCopy.If(x, cond, thenp, elsep)
            }
            cons <$> traverse(cond) <*> traverse(thenp) traverse(elsep)
        case x @ Match (selector, cases) =>
            val cons = { (selector: Tree) => (cases: List[CaseDef]) =>
                treeCopy.Match(x, selector, cases)
            }
            cons <$> traverse(selector) <*> (cases map traverseCaseDef _ sequence)
        case x @ Return(expr) =>
            val cons = { (expr: Tree) =>
                treeCopy.Return(x, expr)
            }
            cons <$> traverse(expr)
        case x @ Try(block, catches, finalizer) =>
            val cons = { (block: Tree) => (catches: List[CaseDef]) => (finalizer: Tree) =>
                treeCopy.Try(x, block, catches, finalizer)
            }
            cons <$> traverse(block) <*> (catches map traverseCaseDef _ sequence) <*> traverse(finalizer)
        case x @ Throw(expr) =>
            val cons = { (expr: Tree) =>
                treeCopy.Throw(x, expr)
            }
            cons <$> traverse(expr)
        case x @ New(tpt) =>
            val cons = { (tpt: Tree) =>
                treeCopy.New(x, tpt)
            }
            cons <$> traverse(tpt)
        case x @ Typed(expr, tpt) =>
            val cons = { (expr: Tree) => (tpt: Tree) =>
                treeCopy.Typed(expr, tpt)
            }
            cons <$> traverse(expr) <*> traverse(tpt)
        case x @ TypeApply(fun, args) =>
            val cons = { (fun: Tree) => (args: List[Tree]) =>
                treeCopy.TypeApply(x, fun, args)
            }
            cons <$> traverse(fun) <*> (args map traverse _ sequence)
        case x @ Apply(fun, args) =>
            val cons = { (fun: Tree) => (args: List[Tree]) =>
                treeCopy.Apply(x, fun, args)
            }
            cons <$> traverse(fun) <*> (args map traverse _ sequence)
        case x @ ApplyDynamic(qual, args) =>
            val cons = { (qual: Tree) => (args: List[Tree]) =>
                treeCopy.ApplyDynamic(qual, args)
            }
            cons <$> traverse(qual) <*> (args map traverse_ sequence)
        case x @ Super(_, _) =>
            pure(x)
        case x @ This(_) =>
            pure(x)
        case x @ Select(qualifier, selector) =>
            val cons = { (qualifier: Tree) =>
                treeCopy.Select(x, qualifier, selector)
            }
            cons <$> traverse(qualifier)
        case x @ Ident(_) =>
            pure(x)
        case x @ Literal(_) =>
            pure(x)
        case x @ TypeTree() =>
            pure(x)
        case x @ Annotated(annot, arg) =>
            val cons = { (annot: Tree) => (arg: Tree) =>
                treeCopy.Annotated(x, annot, arg)
            }
            cons <$> traverse(annot) <*> traverse(arg)
        case x @ SingletonTypeTree(ref) =>
            val cons = { (ref: Tree) =>
                treeCopy.SingletonTypeTree(x, ref)
            }
            cons <$> traverse(ref)
        case x @ SelectFromTypeTree(qualifier, selector) =>
            val cons = { (qualifier: Tree) =>
                treeCopy.SelectFromTypeTree(x, qualifier, selector)
            }
            cons <$> traverse(qualifier)
        case x @ CompoundTypeTree(templ) =>
            val cons = { (templ: Template) =>
                treeCopy.CompoundTypeTree(x, templ)
            }
            cons <$> traverseTemplate(templ)
        case x @ AppliedTypeTree(tpt, args) =>
            val cons = { (tpt: Tree) => (args: List[Tree]) =>
                treeCopy.AppliedTypeTree(x, tpt, args)
            }
            cons <$> traverse(tpt) <*> (args map traverse _ sequence)
        case x @ TypeBoundsTree(lo, hi) =>
            val cons = { (lo: Tree) => (hi: Tree) =>
                treeCopy.TypeBoundsTree(x, lo, hi)
            }
            cons <$> traverse(lo) <*> traverse(hi)
        case x @ ExistentialTypeTree(tpt, whereClauses) =>
            val cons = { (tpt: Tree) => (whereClauses: List[Tree]) =>
                treeCopy.ExistentialTypeTree(x, tpt, whereClauses)
            }
            cons <$> traverse(tpt) <*> (whereClauses map traverse _ sequence)
        case x @ StubTree =>
            pure(x)
            */
    }
    
    val treeCopy: TreeCopier = new LazyTreeCopier
}

