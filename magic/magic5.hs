
data OddTerm = App OddTerm OddTerm | Embed NormalTerm

data NormalTerm = S0 | S1 NormalTerm | S2 NormalTerm NormalTerm | K0 | K1 NormalTerm

norm :: OddTerm -> NormalTerm
norm (Embed t) = t
norm (App car cdr) = case norm car of
                          S0 -> S1 (norm cdr)
                          S1 a -> S2 a (norm cdr)
                          S2 a b -> let
                                      a' = Embed a
                                      b' = Embed b
                                      ac = App a' cdr
                                      bc = App b' cdr
                                    in
                                      norm $ App ac bc
                          K0 -> K1 (norm cdr)
                          K1 a -> a



