
{-# LANGUAGE TemplateHaskell #-}

module Simplify where

import Language.Haskell.TH
import Language.Haskell.TH.Quote

import Control.Monad
import Control.Applicative

import Simple
import ExpUtils

instance Applicative Q where
    pure  = return
    (<*>) = ap

infixl 4 </$>
f </$> x = f <*> (pure x)

expToSimpExp :: Exp -> Q SimpExp
expToSimpExp (VarE n) = return $ VarSE n
expToSimpExp (ConE c) = return $ ConSE c
expToSimpExp (LitE l) = return $ LitSE l
expToSimpExp (AppE x1 x2) = e2seApp x1 x2
expToSimpExp (InfixE mx1 x2 mx3) = e2seInfix mx1 x2 mx3
expToSimpExp (LamE pats body) = e2seLam pats body
expToSimpExp (TupE xs) = e2seTup xs
expToSimpExp (CondE t i e) = e2seCond t i e
expToSimpExp (LetE decs x) = e2seLet decs x
expToSimpExp (CaseE x matches) = e2seCase x matches
expToSimpExp (DoE sts) = e2seDo sts
expToSimpExp (CompE sts) = e2seComp sts
expToSimpExp (ArithSeqE rng) = e2seArithSeq rng
expToSimpExp (ListE xs) = e2seList xs
expToSimpExp (SigE x s) = e2seSig x s
expToSimpExp (RecConE n fields) = e2seRecCon n fields
expToSimpExp (RecUpdE x fields) = e2seRecUpd x fields

bindAllSE :: SimpExp -> [SimpExp] -> SimpExp
bindAllSE f [] = f
bindAllSE f (x : xs) = bindAllSE (AppSE f x) xs

e2seApp :: Exp -> Exp -> Q SimpExp
e2seApp x1 x2 =
    AppSE <$> x1' <*> x2'
    where
        x1' = expToSimpExp x1
        x2' = expToSimpExp x2

e2seInfix :: Maybe Exp -> Exp -> Maybe Exp -> Q SimpExp
e2seInfix Nothing op Nothing =
    expToSimpExp op
e2seInfix (Just x1) op Nothing =
    AppSE <$> op' <*> x1'
    where
        op' = expToSimpExp op
        x1' = expToSimpExp x1
e2seInfix (Just x1) op (Just x2) =
    AppSE <$> (AppSE <$> op' <*> x1') <*> x2'
    where
        op' = expToSimpExp op
        x1' = expToSimpExp x1
        x2' = expToSimpExp x2
e2seInfix Nothing op (Just x2) =
    AppSE <$> (AppSE <$> qFlip <*> op') <*> x2'
    where
        op' = expToSimpExp op
        x2' = expToSimpExp x2
        qFlip = expToSimpExp =<< [|flip|]

e2seLam :: [Pat] -> Exp -> Q SimpExp
e2seLam pats body = do
    argNames <- aliasNames pats
    let
        body' = addCases argNames pats body
    body'' <- expToSimpExp body'
    return $ buildLambda argNames body''

aliasNames :: [Pat] -> Q [Name]
aliasNames pats = sequence $ map aliasName pats

aliasName :: Pat -> Q Name
aliasName (VarP n) = return n
aliasName _ = newName "arg"

addCases :: [Name] -> [Pat] -> Exp -> Exp
addCases args pats body = foldr (uncurry addCase) body $ zip args pats

addCase :: Name -> Pat -> Exp -> Exp
addCase arg (VarP n) body = body
addCase n p body =
    CaseE (VarE n) [Match p (NormalB body) []]

buildLambda :: [Name] -> SimpExp -> SimpExp
buildLambda [] body = body
buildLambda (name : names) body =
    LamSE name (buildLambda names body)

e2seTup :: [Exp] -> Q SimpExp
e2seTup xs = do
    mkT <- tupList (length xs)
    xs' <- mapM expToSimpExp xs
    return $ bindAllSE mkT xs'

tupList :: Int -> Q SimpExp
tupList 1 = MessySE <$> [|id|]
tupList n = do
    names <- replicateM n $ newName "tupList"
    let
        pats = map VarP names
        body = TupE (map VarE names)
    return $ MessySE $ LamE pats body

buildTuple :: [SimpExp] -> Q SimpExp
buildTuple xs = do
    con <- tupList $ length xs
    return $ bindAllSE con xs

tupAcc :: Int -> Int -> Q Exp
tupAcc 1 _ = [|id|]
tupAcc n k = do
    elemNames <- replicateM n $ newName "tupAcc"
    let
        elemPats = VarP <$> elemNames
        elemVar = VarE $ elemNames !! k
    return $ LamE [TupP elemPats] elemVar

e2seCond :: Exp -> Exp -> Exp -> Q SimpExp
e2seCond t i e = do
    t' <- expToSimpExp t
    i' <- expToSimpExp i
    e' <- expToSimpExp e
    func <- [|fIf|] >>= expToSimpExp
    return $ bindAllSE func [t', i', e']

fIf :: Bool -> a -> a -> a
fIf True x _ = x
fIf False _ y = y

e2seLet :: [Dec] -> Exp -> Q SimpExp
e2seLet decs body = do
    decs' <- fmap (id =<<) $ sequence $ decToSimpDecs <$> decs
    body' <- expToSimpExp body
    return $ letify decs' body'

letify :: [SimpDec] -> SimpExp -> SimpExp
letify [] body = body
letify decs body = LetSE decs body

e2seCase :: Exp -> [Match] -> Q SimpExp
e2seCase x matches = do
    comb <- caseComb matches
    lams <- sequence $ matchLambda <$> matches
    x'   <- expToSimpExp x
    return $ bindAllSE comb (x' : lams)

caseComb :: [Match] -> Q SimpExp
caseComb matches = MessySE <$> (caseComb' matches)

caseComb' :: [Match] -> Q Exp
caseComb' matches = do
    argName <- newName "caseArg"
    takeNames <- replicateM (length matches) $ newName "matchBody"
    let
        argPat = VarP argName
        argVar = VarE argName
        takePats = VarP <$> takeNames
        takeVars = VarE <$> takeNames
    matches' <- caseCombMatches takeVars matches
    return $ LamE (argPat:takePats) $ CaseE argVar matches'

caseCombMatches :: [Exp] -> [Match] -> Q [Match]
caseCombMatches takeVars matches =
    sequence $ zipWith caseCombMatch takeVars matches

caseCombMatch :: Exp -> Match -> Q Match
caseCombMatch takeVar (Match pat body whrs) = do
    let names = patNames pat
    body' <- caseCombMatchBody takeVar names body
    return $ Match pat body' []

caseCombMatchBody :: Exp -> [Name] -> Body -> Q Body
caseCombMatchBody takeVar names (NormalB x) =
    let
        ex = bindAllE takeVar (VarE <$> names)
    in
        return $ NormalB ex
caseCombMatchBody takeVar names (GuardedB gxs) = do
    let n = length gxs
    tupAccs <- sequence $ tupAcc n <$> [0..n]
    let gxs' = zipWith (caseCombGuardApply takeVar names) tupAccs gxs
    return $ GuardedB gxs'

caseCombGuardApply :: Exp -> [Name] -> Exp -> (Guard, Exp) -> (Guard, Exp)
caseCombGuardApply takeVar names tupAccK (guard, _) =
    (guard, x') where
        gNames = guardNames guard
        names' = names ++ gNames
        vars   = VarE <$> names'
        x' = bindAllE (AppE tupAccK takeVar) vars

matchLambda :: Match -> Q SimpExp
matchLambda (Match pat body whrs) =
    let
        names = patNames pat
        parts = bodyParts body
        qLams = [buildLambda (names ++ bNames) <$> (expToSimpExp x)
                | (bNames, x) <- parts
            ]
    in do
        lams  <- sequence qLams
        whrs' <- fmap (id =<<) $ sequence $ decToSimpDecs <$> whrs
        tup   <- buildTuple lams
        return $ letify whrs' tup

bodyParts :: Body -> [([Name], Exp)]
bodyParts (NormalB x) = [([], x)]
bodyParts (GuardedB gxs) =
    [(guardNames g, x) | (g, x) <- gxs]

bodyExps :: Body -> [Exp]
bodyExps (NormalB x) = [x]
bodyExps (GuardedB gxs) = [x | (g, x) <- gxs]

guardNames :: Guard -> [Name]
guardNames (NormalG _) = []
guardNames (PatG sts) = stmtNames =<< sts

stmtNames :: Stmt -> [Name]
stmtNames (BindS pat x) = patNames pat
stmtNames (LetS decs) = decNames =<< decs
stmtNames (NoBindS _) = []
stmtNames (ParS stss) = error "What IS this?"
    
patNames :: Pat -> [Name]
patNames (LitP _) = []
patNames (VarP n) = [n]
patNames (TupP ps) = ps >>= patNames
patNames (ConP n ps) = n : (ps >>= patNames)
patNames (InfixP p1 n p2) =
    n : (patNames p1) ++ (patNames p2)
patNames (TildeP p) = patNames p
patNames (BangP p) = patNames p
patNames (AsP n p) = n : (patNames p)
patNames WildP = []
patNames (RecP n fps) = n : (fps >>= recPatNames)
patNames (ListP ps) = ps >>= patNames
patNames (SigP p _) = patNames p

recPatNames :: FieldPat -> [Name]
recPatNames (n, p) = n : (patNames p)

decNames :: Dec -> [Name]
decNames (FunD name clauses) = [name]
decNames (ValD pat body decs) = patNames pat
decNames (DataD cxt name tys cons dervs) = name : (conNames =<< cons)
decNames (NewtypeD cxt name tys con dervs) = name : conNames con
decNames (TySynD name tys typ) = [name]
decNames (ClassD cxt name tys fdeps meths) = name : (decNames =<< meths)
decNames (InstanceD cxt typ meths) = []
decNames (SigD name sig) = [name]
decNames (ForeignD forgn) = []
decNames (PragmaD prag) = []
decNames (FamilyD flavor name tys mkind) = [name]
decNames (DataInstD cxt name typs cons someNames) =
    error "I don't know what DataInstD is"
decNames (NewtypeInstD cxt name typs con someNames) = 
    error "Not implemented (decNames NewtypeInstD)"
decNames (TySynInstD name typs typ) = []

conNames :: Con -> [Name]
conNames (NormalC n _) = [n]
conNames (RecC n fs) = n : [n' | (n',_,_) <- fs]
conNames (InfixC _ n _) = [n]
conNames (ForallC _ _ c) = conNames c

decToSimpDecs :: Dec -> Q [SimpDec]
decToSimpDecs (FunD nm clauses) = error "no"
decToSimpDecs (ValD pat body decs) = do
    comb <- valDecComb pat body
    tempName <- newName "tmpGroup"
    let
        names    = patNames pat
        n        = length names
        comb'    = MessySE comb
    bExps'    <- sequence $ expToSimpExp <$> (bodyExps body)
    accs      <- sequence $ tupAcc n <$> [0..n]
    decs'     <- fmap (id =<<) $ sequence $ decToSimpDecs <$> decs
    let
        partExps' = [
                AppSE (MessySE acc) (VarSE tempName) | acc <- accs
            ]
        tempDec  = DecSD tempName $
            letify decs' $
                bindAllSE comb' bExps'
        partDecs = [DecSD name exp |
            (name, exp) <- zip names partExps']
    return $ tempDec : partDecs
decToSimpDecs (DataD cxt name tys cons dervs) = undefined
decToSimpDecs (NewtypeD cxt name tys con dervs) = undefined
decToSimpDecs (TySynD name tys typ) = undefined
decToSimpDecs (ClassD cxt name tys fdeps meths) = undefined
decToSimpDecs (InstanceD cxt typ meths) = undefined
decToSimpDecs (SigD name sig) = undefined
decToSimpDecs (ForeignD forgn) = undefined
decToSimpDecs (PragmaD prag) = undefined
decToSimpDecs (FamilyD flavor name tys mkind) = undefined
decToSimpDecs (DataInstD cxt name typs cons someNames) =
    error "I don't know what DataInstD is"
decToSimpDecs (NewtypeInstD cxt name typs con someNames) = 
    error "Not implemented (decToSimpDecs NewtypeInstD)"
decToSimpDecs (TySynInstD name typs typ) = undefined

valDecComb :: Pat -> Body -> Q Exp
valDecComb pat body = do
    (argNames, body') <- valDecCombBody body
    let
        lamBody = LetE [ValD pat body' []] letBody
        letBody = TupE (map VarE $ patNames pat)
    return $ LamE (map VarP argNames) lamBody

valDecCombBody :: Body -> Q ([Name], Body)
valDecCombBody (NormalB x) = do
    argName <- newName "valCombArg"
    return $ ([argName], NormalB (VarE argName))
valDecCombBody (GuardedB gxs) = do
    argNames <- replicateM (length gxs) $ newName "valCombArg"
    let
        f (guard, x) argName = gx' where
            gx' = (guard, VarE argName)
        gxs' =
            zipWith f gxs argNames
    return $ (argNames, GuardedB gxs')

e2seDo :: [Stmt] -> Q SimpExp
e2seDo sts = (expToSimpExp =<<) $ unwindDo sts

unwindDo :: [Stmt] -> Q Exp
unwindDo [NoBindS x] = return x
unwindDo ((BindS pat x) : sts) = do
    bind <- [|(>>=)|]
    rest <- unwindDo sts
    let lam = LamE [pat] rest
    return $ AppE (AppE bind x) lam
unwindDo ((LetS decs) : sts) = do
    rest <- unwindDo sts
    return $ LetE decs rest
unwindDo ((NoBindS x) : sts) = do
    pipe <- [|(>>)|]
    rest <- unwindDo sts
    return $ AppE (AppE pipe x) rest
unwindDo ((ParS nsts) : sts) =
    error "I don't know what this is"

e2seComp :: [Stmt] -> Q SimpExp
e2seComp sts = e2seDo =<< (returnLast sts)

returnLast :: [Stmt] -> Q [Stmt]
returnLast sts = do
    ret <- [|return|]
    let last' = case (last sts) of
                  NoBindS x -> NoBindS (AppE ret x)
    return $ (init sts) ++ [last']

e2seArithSeq :: Range -> Q SimpExp
e2seArithSeq (FromR x) = do
    f <- [|fFrom|]
    expToSimpExp $ AppE f x
e2seArithSeq (FromThenR x1 x2) = do
    f <- [|fFromThen|]
    expToSimpExp $ AppE (AppE f x1) x2
e2seArithSeq (FromToR x1 x2) = do
    f <- [|fFromTo|]
    expToSimpExp $ AppE (AppE f x1) x2
e2seArithSeq (FromThenToR x1 x2 x3) = do
    f <- [|fFromThenTo|]
    expToSimpExp $ AppE (AppE (AppE f x1) x2) x3

fFrom n = [n..]
fFromThen a b = [a,b ..]
fFromTo a b = [a .. b]
fFromThenTo a a2 b = [a,a2 .. b]

e2seList :: [Exp] -> Q SimpExp
e2seList [] = expToSimpExp =<< [|nil|]
e2seList (x : xs) = AppSE <$> cx' <*> xs' where
    cx' = AppSE <$> c' <*> x'
    c'  = expToSimpExp =<< [|cons|]
    x'  = expToSimpExp x
    xs' = e2seList xs

nil :: [a]
nil = []

cons :: a -> [a] -> [a]
cons = (:)

e2seSig :: Exp -> Type -> Q SimpExp
e2seSig x s = SigSE <$> x' </$> s where
    x' = expToSimpExp x

e2seRecCon :: Name -> [FieldExp] -> Q SimpExp
e2seRecCon name fieldExps =  do
    lamNames <- replicateM (length fieldExps) $ newName "recCon"
    let
        exps    = [x | (n, x) <- fieldExps]
        lam     = LamE (map VarP lamNames) lamBody
        lamBody = RecConE name $ zipWith mkFE lamNames fieldExps
        mkFE ln (n, _) = (n, VarE ln)
    exps' <- sequence $ map expToSimpExp exps
    return $ bindAllSE (MessySE lam) exps'

e2seRecUpd :: Exp -> [FieldExp] -> Q SimpExp
e2seRecUpd recX fieldExps = do
    lamNames <- replicateM (length fieldExps) $ newName "recCon"
    recName <- newName "rec"
    let
        exps    = [x | (n, x) <- fieldExps]
        lam     = LamE ((VarP recName) : (map VarP lamNames)) lamBody
        lamBody = RecUpdE (VarE recName) $ zipWith mkFE lamNames fieldExps
        mkFE ln (n, _) = (n, VarE ln)
    exps' <- sequence $ map expToSimpExp exps
    exps'' <- (:) <$> (expToSimpExp recX) </$> exps'
    return $ bindAllSE (MessySE lam) exps''

