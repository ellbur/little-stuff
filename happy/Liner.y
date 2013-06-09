
{
module Liner where

import ParserState
import Lexer
}

%name      smoothLines
%tokentype { Token      }
%monad     { PR         } { bindPR } { returnPR }
%error     { handleLineError }

%token
	'('    { TLParen }
	')'    { TRParen }
    nl     { TNL     }
    eof    { TEOF    }
    other  { _       }
%%

File    : Bunches eof   { reverse (TEOF:$1) }

Bunches :               { [] }
        | Bunches Bunch { $2 ++ $1 }

Bunch   : nl              { [TNL] }
        | Bunch other     { $2:$1 }
        | '(' InParen ')' { [TRParen] ++ $2 ++ [TLParen] }

InParen :                 { []    }
        | InParen other   { $2:$1 }
        | InParen nl      { $1    }
        | '(' InParen ')' { [TRParen] ++ $2 ++ [TLParen] }

{
handleLineError :: [Token] -> PR a
handleLineError toks =
    parseError $ "Got a line error near " ++ (show toks)
}

