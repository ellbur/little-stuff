
open Batteries
open Printf
open Data
open Run
;;

module D = Data;;

let plus_int_op args =
    let x1 = cell_int args.(0)
    and x2 = cell_int args.(1) in
    make_cell (D.Int (x1 + x2))
;;

let plus_int = make_cell
    (D.Builtin {builtin_call = plus_int_op})

let f = {
    formula_car = plus_int;
    formula_cdr = make_dlist [|
        make_cell (D.Int 2);
        make_cell (D.Int 3)
    |];
}

let x = make_cell (D.Formula f)
let y = eval_cell x
;;

printf "%d\n" (cell_int y)


