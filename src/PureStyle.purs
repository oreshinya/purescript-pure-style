module PureStyle
  ( StyleSheet
  , createStyleSheet
  , getStyle
  , registerStyle
  ) where

import Prelude

import Data.Char (toCharCode)
import Data.Foldable (foldr)
import Data.Int (base36, toStringAs)
import Data.Int.Bits (xor, zshr)
import Data.String (Pattern(..), Replacement(..), replaceAll)
import Data.String.CodeUnits (toCharArray)
import Effect.Ref (Ref, modify_, new, read)
import Effect.Unsafe (unsafePerformEffect)

-- | The type of stylesheet.
newtype StyleSheet = StyleSheet (Ref String)

-- | Create a stylesheet.
createStyleSheet :: StyleSheet
createStyleSheet = StyleSheet $ unsafePerformEffect $ new ""

-- | Get all styles in a stylesheet.
getStyle :: StyleSheet -> String
getStyle (StyleSheet ref) = unsafePerformEffect $ read ref

-- | Define styles with css string.
-- |
-- | This generate a hash from css string, and replace `&` with its hash in css string, finally return its hash string.
-- | So, returned string can be used as class name.
-- |
-- | ```purescript
-- | sheet :: StyleSheet
-- | sheet = createStyleSheet
-- |
-- | sampleClass :: String
-- | sampleClass = registerStyle sheet
-- |   """
-- |   .& {
-- |     width: 100px;
-- |     height: 100px;
-- |   }
-- |   .&:hover {
-- |     width: 100px;
-- |     height: 100px;
-- |   }
-- |   .&:hover .selected {
-- |     color: blue;
-- |   }
-- |   """
-- | ```
-- |
-- | Added styles to stylesheet like:
-- | ```css
-- | .pz66dqm {
-- |   width: 100px;
-- |   height: 100px;
-- | }
-- | .pz66dqm:hover {
-- |   width: 100px;
-- |   height: 100px;
-- | }
-- | .pz66dqm:hover .selected {
-- |   color: blue;
-- | }
-- | ```
registerStyle :: StyleSheet -> String -> String
registerStyle (StyleSheet ref) style = unsafePerformEffect do
  modify_ (flip append output) ref
  pure name
  where
    name = "p" <> generateHash style
    output = replaceToken name style

generateHash :: String -> String
generateHash str = toStringAs base36 $ zshr seed 0
  where
    culc char value = xor (value * 33) (toCharCode char)
    seed = foldr culc 5381 $ toCharArray str

replaceToken :: String -> String -> String
replaceToken instead target =
  replaceAll (Pattern "&") (Replacement instead) target
