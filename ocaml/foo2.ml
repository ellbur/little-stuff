
open Printf
open Array

type cell = CInt of int;;

type formula = Leaf of cell | Call of call
and call = {
    car : string;
    cdr : string list;
};;

let x = [| 0; 1; 2 |] in
printf "%d\n" (get x 0)
;;


