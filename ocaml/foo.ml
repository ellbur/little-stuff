
open Printf

type 'a maybe = Nothing | Just of 'a ;;

let x = Just 6 in
match x with
      Nothing -> print_endline "Hi"
    | Just x  -> printf "%d\n" x ;;


