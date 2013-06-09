
open Batteries
open Printf
open Data

module D = Data

let dlist_map f l =
    {
        dlist_elems = Array.map f l.dlist_elems;
        dlist_named = l.dlist_named
    }
;;

let make_dlist a =
    {
        dlist_elems = a;
        dlist_named = PMap.empty
    }
;;

let blank_attributes : (cell, cell) PMap.t = PMap.empty
;;

let make_cell t =
    { cell_token = t; cell_attributes = blank_attributes }
;;

let cell_int t =
    match t.cell_token with D.Int x -> x
;;

let call_func f args =
    make_cell D.Nil
;;

let call_builtin b args =
    b.builtin_call args.dlist_elems
;;

let call_cell c args =
    match c.cell_token with
      D.Func f    -> call_func f args
    | D.Builtin b -> call_builtin b args
;;

let rec
    eval_formula f =
        let car = eval_cell f.formula_car in
        let cdr = dlist_map eval_cell f.formula_cdr in
        call_cell car cdr
    
    and
    eval_cell c =
        match c.cell_token with
          D.Formula f -> eval_formula f
        | _           -> c
;;

