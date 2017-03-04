
range n = [0..n-1]

all_d n =
    if n == 0
        then [[]]
    else
        let
            before = all_d (n - 1)
        in
            [[x] ++ y | x <- range 10 , y <- before]

to_test = all_d 5

tablify [] = [0, 0, 0, 0, 0,  0, 0, 0, 0, 0]
tablify (x : xs) = 
    let (a, y : b) = splitAt x (tablify xs)
        in a ++ [y + 1] ++ b

check_fib nums = let
        table = tablify nums 
    in
        flip any [(a,b) | a <- range 10, b <- range 10] $ \(a, b) ->
            let
                follow table' a b =
                    if (sum table') == 0
                       then True
                       else if (table' !! a) <= 0
                                then False
                                else let
                                    (u, y : v) = splitAt a table'
                                    table'' = u ++ [y-1] ++ v
                                  in
                                    follow table'' b ((a+b) `mod` 10)
            in
                follow table a b
        
total = sum [
    (
        if check_fib s
           then 1
           else 0
       )
           
       | s <- to_test
    ]

main = print total

