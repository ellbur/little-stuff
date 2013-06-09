
{
module Lexer where
}

%wrapper "basic"

tokens :-
    \n         { \s -> TNL           }
    $white     ;
	[0-9]+     { \s -> TInt (read s) }
	\+         { \s -> TPlus         }
    \-         { \s -> TMinus        }
	\*         { \s -> TTimes        }
    \/         { \s -> TDivide       }
	\(         { \s -> TLParen       }
	\)         { \s -> TRParen       }

{
data Token =
	  TLParen
	| TRParen
	| TInt Integer
	| TPlus
    | TMinus
	| TTimes
    | TDivide
    | TNL
    | TEOF
	deriving (Show,Eq)

lex :: String -> [Token]
lex str =
    (alexScanTokens str) ++ [TEOF]
}

