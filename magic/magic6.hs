
data Idiom = Idiom {
        i_name :: String,
        i_pure :: NormalTerm,
        i_ap   :: NormalTerm,
        i_bind :: NormalTerm
    }

instance Eq Idiom where
    a == b = (i_name a) == (i_name b)
    
instance Show Idiom where
    show a = i_name a

data OddTerm = App OddTerm OddTerm | AntiPure Idiom OddTerm | Pure Idiom OddTerm | Embed NormalTerm
    deriving (Show)

data NormalTerm = S0 | S1 NormalTerm | S2 NormalTerm NormalTerm | K0 | K1 NormalTerm
    deriving (Show)

asReducibleCar :: NormalTerm -> Either (NormalTerm -> NormalTerm) (OddTerm -> OddTerm)
asReducibleCar S0 = Left $ \cdr -> S1 cdr
asReducibleCar (S1 a) = Left $ \cdr -> S2 a cdr
asReducibleCar (S2 a b) = Right $ \cdr -> let
                                            a' = Embed a
                                            b' = Embed b
                                            ac = App a' cdr
                                            bc = App b' cdr
                                          in 
                                            App ac bc
asReducibleCar K0 = Left $ \cdr -> K1 cdr
asReducibleCar (K1 a) = Right $ \cdr -> Embed a

norm :: [Idiom] -> OddTerm -> (NormalTerm, [Idiom])
norm pureStack (Embed t) = (t, [])
norm pureStack (AntiPure idiom t) =
    let
        (t', antiPures) = norm pureStack t
    in
        if idiom `elem` antiPures
           then error "Not implemented: monads"
           else (t', idiom : antiPures)
norm pureStack (Pure idiom t) =
    let
        (t', antiPures) = norm (idiom : pureStack) t
    in
        case antiPures of
             [] -> norm pureStack $ App (Embed (i_pure idiom)) (Embed t')
             (top : rest) -> if top == idiom
                                then (t', rest)
                                else error "Not implemented: sequencing"
norm pureStack (App car cdr) = case norm pureStack car of
                                    (car', []) -> case asReducibleCar car' of
                                                       Left f -> case norm pureStack cdr of
                                                                      (cdr', []) -> (f cdr', [])
                                                                      (cdr', cdrIdioms) -> applyIdiomatically pureStack (car', []) (cdr', cdrIdioms)
                                                       Right f -> norm pureStack (f cdr)
                                    (car', carIdioms) -> case norm pureStack cdr of
                                                              (cdr', cdrIdioms) ->
                                                                applyIdiomatically pureStack (car', carIdioms) (cdr', cdrIdioms)

applyIdiomatically :: [Idiom] -> (NormalTerm, [Idiom]) -> (NormalTerm, [Idiom]) -> (NormalTerm, [Idiom])
applyIdiomatically ps (car, []) (cdr, []) = norm ps $ App (Embed car) (Embed cdr)
applyIdiomatically ps (car, carIdiom : carIdioms) (cdr, []) = carLeads ps carIdiom (car, carIdioms) (cdr, [])
applyIdiomatically ps (car, []) (cdr, cdrIdiom : cdrIdioms) = cdrLeads ps cdrIdiom (car, []) (cdr, cdrIdioms)
applyIdiomatically ps (car, carIdiom : carIdioms) (cdr, cdrIdiom : cdrIdioms) = 
    if carIdiom == cdrIdiom
       then lineUp ps carIdiom (car, carIdioms) (cdr, cdrIdioms)
       else search ps where
           search [] = error "Ambiguous idiomatic app"
           search (pureTop : pureStack') =
               if pureTop == carIdiom
                  then carLeads ps pureTop (car, carIdioms) (cdr, cdrIdiom : cdrIdioms)
               else if pureTop == cdrIdiom
                  then cdrLeads ps pureTop (car, carIdiom : carIdioms) (cdr, cdrIdioms)
               else search pureStack'

carLeads :: [Idiom] -> Idiom -> (NormalTerm, [Idiom]) -> (NormalTerm, [Idiom]) -> (NormalTerm, [Idiom])
carLeads pureStack idiom car cdr = (t', idiom : idioms') where
    on = applyIdiomatically pureStack
    a = (i_ap idiom, [])
    p = (i_pure idiom, [])
    (t', idioms') = a `on` car `on` (p `on` cdr)

cdrLeads :: [Idiom] -> Idiom -> (NormalTerm, [Idiom]) -> (NormalTerm, [Idiom]) -> (NormalTerm, [Idiom])
cdrLeads pureStack idiom car cdr = (t', idiom : idioms') where
    on = applyIdiomatically pureStack
    a = (i_ap idiom, [])
    p = (i_pure idiom, [])
    (t', idioms') = a `on` (p `on` car) `on` cdr

lineUp :: [Idiom] -> Idiom -> (NormalTerm, [Idiom]) -> (NormalTerm, [Idiom]) -> (NormalTerm, [Idiom])
lineUp pureStack idiom car cdr = (t', idiom : idioms') where
    on = applyIdiomatically pureStack
    a = (i_ap idiom, [])
    (t', idioms') = a `on` car `on` cdr
    
eval = norm []

s = Embed S0
k = Embed K0
a = App

i = s `a` k `a` k

x = Idiom "x" K0 S0 undefined
y = Idiom "y" K0 S0 undefined

xy = Pure x $ Pure y $ (AntiPure x i) `a` (AntiPure y i)

