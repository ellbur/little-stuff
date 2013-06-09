
open Batteries

type token =
      Nil
    | Int     of int
    | Float   of float
    | String  of string
    | Bool    of bool
    | Formula of formula
    | Exp     of expression
    | Env     of environ
    | Func    of func
    | Builtin of builtin
    | Ext     of extptr
and cell = {
    cell_token : token;
    mutable cell_attributes : (cell, cell) PMap.t;
}
and formula = {
    formula_car : cell;
    formula_cdr : dlist;
}
and dlist = {
    dlist_elems : cell array;
    mutable dlist_named : (cell, int) PMap.t;
}
and expression = {
    expression_formula : cell;
    expression_closure : cell;
}
and environ = {
    mutable environ_members : (cell, enventry) PMap.t;
    environ_parent : cell;
}
and enventry = {
    enventry_formula : cell;
    enventry_value   : cell option;
}
and func = {
    func_body      : cell;
    func_closure   : cell;
    func_arg_names : cell array;
}
and builtin = {
    builtin_call : cell array -> cell;
}
and extptr = {
    extptr_call : cell -> cell;
}


