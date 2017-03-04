
data Idiom = Idiom {
        i_name :: String,
        i_pure :: Tree,
        i_ap   :: Tree,
        i_bind :: Tree
    }

instance Eq Idiom where
    a == b = (i_name a) == (i_name b)
    
instance Ord Idiom where
    compare a b = compare (i_name a) (i_name b)
    
instance Show Idiom where
    show a = i_name a

data Tree = S | K | App Tree Tree | AntiPure Idiom Tree | Pure Idiom Tree
    deriving (Show, Eq, Ord)

norm :: [Idiom] -> Tree -> Tree
norm pureStack tree = case tree of
    S -> S
    K -> K
    App (App (App S a) b) c -> norm pureStack (App (App a c) (App b c))
    App (App K a) b -> a
    App S a  -> combine pureStack S a
    App (App S a) b -> combine pureStack (combine pureStack S a) b
    App K a -> combine pureStack K a
    App (AntiPure idiom a) b -> case norm pureStack b of
                                     AntiPure idiom' b -> if idiom == idiom'
                                                             then norm pureStack $ AntiPure idiom ((i_ap idiom) `App` a `App` b)
                                                             else case pureStack of
                                                                       [] -> error "Ambiguous pairing at car"
                                                                       (top : _) -> if top == idiom
                                                                                       then ((i_ap idiom) `App` a `App` ((i_pure idiom) `App` b))
                                                                                       else ((i_ap idiom') `App` ((i_pure idiom') `App` a) `App` b)
    -- TODO: monads
    AntiPure idiom tree -> AntiPure idiom (norm pureStack tree)
    Pure idiom tree -> case norm (idiom : pureStack) tree of
                            AntiPure idiom' tree -> if idiom == idiom'
                                                       then tree
                                                       else error "Not implemented: sequencing"
    App car cdr -> norm (norm pureStack car) `App` cdr
    tree        -> tree

foo = S `App` K `App` K `App` S

