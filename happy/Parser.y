
{
module Parser where

import ParserState
import Lexer
}

%name      parse
%tokentype { Token      }
%monad     { PR         } { bindPR } { returnPR }
%error     { handleParseError }

%token
	'('    { TLParen }
	')'    { TRParen }
	num    { TInt $$ }
	'+'    { TPlus   }
    '-'    { TMinus  }
	'*'    { TTimes  }
    '/'    { TDivide }
    nl     { TNL     }
    eof    { TEOF    }

%%
                      
File : Exps eof       { reverse $1 }

Exps : Exps1          { $1 }
     | Exps2          { $1 }

Exps1 :               { [] }
      | Exps nl       { $1 }

Exps2 : Exps1 Exp     { $2:$1 }
                      
Exp  : Exp1           { $1 }

Exp1 : Exp1 Ifx1 Exp2 { C $2 [$1, $3] }
	 | Exp2           { $1 }

Exp2 : Exp2 Ifx2 Exp3 { C $2 [$1, $3] }
     | Exp3           { $1 }

Exp3 : Term           { $1 }

Term : '(' Exp ')'    { $2 }
     | num            { T (TInt $1) }

Ifx1 : '+' { "+" }
     | '-' { "-" }

Ifx2 : '*' { "*" }
     | '/' { "/" }

{
handleParseError :: [Token] -> PR a
handleParseError toks =
    parseError $ "Got a parse error near " ++ (show toks)

data Exp = T Token | C String [Exp]
	deriving (Show,Eq)
}

