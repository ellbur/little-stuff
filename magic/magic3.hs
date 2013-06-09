
import Data.Set as Set

data Object = Pure Idiom | AntiPure Idiom
    | Weak String (Object -> OpenMagic)
    | Strong String (OpenMagic -> OpenMagic)

instance Show Object where
    show (Pure idiom) = "Pure " ++ (show idiom)
    show (AntiPure idiom) = "AntiPure " ++ (show idiom)
    show (Weak name _) = name
    show (Strong name _) = name

data ClosedMagic = ClosedMagic (Set Idiom) Object
    deriving (Show)

data OpenMagic = OpenMagic ([Idiom] -> ClosedMagic)

close (OpenMagic f) is = f is

eval (OpenMagic f) = f []

data Idiom = Idiom {
        i_name :: String,
        i_pure :: Object -> ClosedMagic,
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
    result idiomStack = m2 idiomStack (close car idiomStack) cdr

m2 :: [Idiom] -> ClosedMagic -> OpenMagic -> OpenMagic
m2 idiomStack (ClosedMagic carIdioms carResult) cdr =
    if Set.null carIdioms
       then m3 idiomStack carResult cdr
       else error "Not implemented: car transforms"

m3 :: [Idiom] -> Object -> OpenMagic -> OpenMagic
m3 idiomStack (Pure idiom) cdr = result where
    -- TODO: We really need to inspect the idiom stack and see if we are allowed to do this.
    (ClosedMagic cdrIdioms cdrResult) = close cdr idiomStack
    result =
        if member idiom cdrIdioms
           then ClosedMagic (delete idiom cdrIdioms) cdrResult
           else close ((i_pure idiom) `m` cdr) idiomStack
m3 idiomStack (AntiPure idiom) cdr = result where
    -- TODO: We really need to inspect the idiom stack and see if we are allowed to do this.
    (ClosedMagic cdrIdioms cdrResult) = close cdr idiomStack
    result =
        if member idiom cdrIdioms
           then error "Not implemented: monads"
           else ClosedMagic (insert idiom cdrIdioms) cdrResult
m3 idiomStack (Strong _ carFunc) cdr = carFunc cdr
m3 idiomStack (Weak _ carFunc) cdr = result where
    (ClosedMagic cdrIdioms cdrObject) = close cdr idiomStack
    result :: ClosedMagic
    result =
        if Set.null cdrIdioms
           then carFunc cdrObject
           else error "Not implemented: transforming via idiom"

weak name f = ClosedMagic empty $ Weak name f
strong name f = ClosedMagic empty $ Strong name f

mI = OpenMagic $ \is -> strong "I" $ \a -> close a is
mK = OpenMagic $ \is -> weak "K" $ \a -> strong "K1" $ \b -> ClosedMagic empty a
mS = OpenMagic $ \is -> weak "S" $ \a -> weak "S1" $ \b -> strong "S2" $ \c -> combineS is a b c

combineS :: [Idiom] -> Object -> Object -> OpenMagic -> ClosedMagic
combineS is a b c = acbc where
    ac :: ClosedMagic
    ac = m3 is a c
    bc = OpenMagic $ \is2 -> m3 is2 b c
    acbc = m2 is ac bc

x = Idiom "x" mK mS undefined

akx = OpenMagic $ \s -> ClosedMagic empty $ AntiPure x
kx = OpenMagic $ \s -> ClosedMagic empty $ Pure x

yo = m mI (m akx mI)
    
dawg = eval yo

