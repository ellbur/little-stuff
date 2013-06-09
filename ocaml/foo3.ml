
open Batteries
open Printf
;;

let m : (int, int) PMap.t = PMap.empty in
let m = PMap.add 0 0 m in
let m = PMap.add 1 5 m in
    printf "%d\n" (PMap.find 1 m)
;;

