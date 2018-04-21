module PureStyle
  ( Style
  , style
  , name
  , output
  ) where

import Prelude

import Data.Char (toCharCode)
import Data.Foldable (foldr)
import Data.Int (base36, toStringAs)
import Data.Int.Bits (xor, zshr)
import Data.String (Pattern(..), Replacement(..), replaceAll, toCharArray)
import Data.Tuple (Tuple(..), fst, snd)



newtype Style = Style (Tuple String String)



style :: String -> Style
style css = Style (Tuple n o)
  where
    n = genName css
    o = genOutput css n



genName :: String -> String
genName css = "p" <> (toStringAs base36 $ zshr seed 0)
  where
    culc char value = xor (value * 33) (toCharCode char)
    seed = foldr culc 5381 $ toCharArray css



genOutput :: String -> String -> String
genOutput css n =
  replaceAll (Pattern "&") (Replacement n) css



name :: Style -> String
name (Style x) = fst x



output :: Style -> String
output (Style x) = snd x
