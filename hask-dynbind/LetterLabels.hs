
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DeriveDataTypeable #-}

module LetterLabels where

import StrType
import Data.Typeable

$(defineLetterLabels' ['a' .. 'z'])
$(defineLetterLabels' ['A' .. 'Z'])
$(defineLetterLabels' ['0' .. '9'])

