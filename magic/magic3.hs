
data Object = Pure Idiom | AntiPure Idiom
    | Weak String (Object -> OpenMagic)
    | Strong String (OpenMagic -> OpenMagic)

instance Show Object where
    show (Pure idiom) = "Pure " ++ (show idiom)
    show (AntiPure idiom) = "AntiPure " ++ (show idiom)
    show (Weak name _) = name
    show (Strong name _) = name

data ClosedMagic = ClosedMagic [Idiom] Object
    deriving (Show)

data OpenMagic = OpenMagic ([Idiom] -> ClosedMagic)

close (OpenMagic f) is = f is

eval (OpenMagic f) = f []

data Idiom = Idiom {
        i_name :: String,
        i_pure :: OpenMagic,
        i_ap   :: OpenMagic,
        i_bind :: OpenMagic
    }

instance Eq Idiom where
    a == b = (i_name a) == (i_name b)
    
instance Ord Idiom where
    compare a b = compare (i_name a) (i_name b)
    
instance Show Idiom where
    show a = i_name a

m :: OpenMagic -> OpenMagic -> OpenMagic
m car cdr = OpenMagic result where
    -- There's something beautifully monadic about this line.
    result pureStack = close (m2 pureStack (close car pureStack) cdr) pureStack

m2 :: [Idiom] -> ClosedMagic -> OpenMagic -> OpenMagic
m2 pureStack (ClosedMagic [] carResult) cdr = m3 pureStack carResult cdr
m2 pureStack (ClosedMagic _ carResult) cdr = error "Not implemented: car transforms"

m3 :: [Idiom] -> Object -> OpenMagic -> OpenMagic
-- How to implement pures:
--   1. Search for idiom in the anti-pure stack.
--   2. If it's not there, this is just P cdr
--   3. If you find it on top, just strip it off.
--   4. If you find it somwhere in the middle, ie you have TOP ++ [idiom] ++ BOTTOM,
--      you need to use the idiom-map to apply anti-pure-TOP to cdr+BOTTOM.
-- Take note that the anti-pure stack is associative.
m3 pureStack (Pure idiom) cdr = result where
    -- From cdr's perspective, when it looks up it seems this idiom in pure.
    pureStack' = idiom : pureStack
    (ClosedMagic cdrIdioms cdrObject) = close cdr pureStack'
    result = search cdrIdioms []
    
    p = i_pure idiom
    a = i_ap idiom
    
    search [] above = p `m` (cdrObject `openWith` cdrIdioms)
    search (cdrIdiom : cdrIdioms') above
        | cdrIdiom == idiom = case above of
                                   [] -> cdrObject `openWith` cdrIdioms'
                                   _  ->
                                        let
                                          antiPureTop = p `m` (multiAntiPure $ reverse above)
                                          cdrPlusBottom = cdrObject `openWith` cdrIdioms'
                                        in
                                          a `m` antiPureTop `m` cdrPlusBottom
        | otherwise  = search cdrIdioms' (cdrIdiom : above)
-- How to implement anti-pures:
--   1. Search to see if the idiom exists already in the anti-pure stack.
--   2. If it does, it's monad time. Too sad.
--   3. If not, just add it to the top of the stack.
m3 pureStack (AntiPure idiom) cdr = result where
    (ClosedMagic cdrIdioms cdrObject) = close cdr pureStack
    result = search cdrIdioms []
    
    search [] above = cdrObject `openWith` (idiom : cdrIdioms)
    search (cdrIdiom : cdrIdioms') above
        | cdrIdiom == idiom = error "Not implemented: monads"
        | otherwise         = search cdrIdioms' (cdrIdiom : above)
    
m3 pureStack (Strong _ carFunc) cdr = carFunc cdr
m3 pureStack (car @ (Weak _ carFunc)) cdr = result where
    (ClosedMagic cdrIdioms cdrObject) = close cdr pureStack
    result :: OpenMagic
    result = case cdrIdioms of
                  [] -> carFunc cdrObject
                  -- TODO: This case can be made more efficient with a higher-degree combinator.
                  (cdrIdiom : cdrIdioms') -> let
                        a = i_ap cdrIdiom
                        p = i_pure cdrIdiom
                        apcarcdr = a `m` (p `m` (open car)) `m` (cdrObject `openWith` cdrIdioms')
                        backOn = multiAntiPure [cdrIdiom]
                     in
                        backOn `m` apcarcdr

weak :: String -> (Object -> OpenMagic) -> OpenMagic
weak name f = OpenMagic $ \is -> ClosedMagic [] $ Weak name f

strong :: String -> ([Idiom] -> OpenMagic -> OpenMagic) -> OpenMagic
strong name f = OpenMagic $ \is -> ClosedMagic [] $ Strong name (\o -> f is o)

open :: Object -> OpenMagic
open obj = OpenMagic $ \is -> ClosedMagic [] obj

openWith :: Object -> [Idiom] -> OpenMagic
openWith obj antiPureStack = OpenMagic $ \is -> ClosedMagic antiPureStack obj

multiAntiPure :: [Idiom] -> OpenMagic
multiAntiPure [] = mI
multiAntiPure (idiom : []) = OpenMagic $ \s -> ClosedMagic [] $ AntiPure idiom
multiAntiPure _ = error "Not implemented: multiple anti pures"

mI = strong "I" $ \is a -> a
mK = weak "K" $ \a -> strong "K1" $ \is b -> open a
mS = weak "S" $ \a -> weak "S1" $ \b -> strong "S2" $ \is c ->
    let
      ac = m (open a) c
      bc = m (open b) c
    in
      m ac bc

x = Idiom "x" mK mS undefined

akx = OpenMagic $ \s -> ClosedMagic [] $ AntiPure x
kx = OpenMagic $ \s -> ClosedMagic [] $ Pure x

sii = mS `m` mI `m` mI
-- This term has no normal form.
siisii = sii `m` sii
-- But this term does!
ok = mK `m` mI `m` siisii
    
f = kx `m` (mK `m` (akx `m` mI))
yo = f `m` mI `m` mS

dawg = eval yo

