module PureStyle
  ( Result
  , Style(..)
  , KeyFrame(..)
  , (:)
  , (:-)
  , (:>)
  , className
  , keyframes
  , media
  , css
  ) where

import Prelude
import Control.Monad.State (State, execState, modify)
import Data.Char (toCharCode)
import Data.Foldable as F
import Data.Int (base36, toStringAs)
import Data.Int.Bits (xor, zshr)
import Data.Maybe (Maybe(..))
import Data.String (Pattern(..), Replacement(..), contains, replaceAll, toCharArray)
import Data.StrMap as S
import Partial.Unsafe (unsafePartial)



type Result =
  { name :: String
  , output :: String
  }

data Style
  = Prop String String
  | Node String (Array Style)

data KeyFrame = KeyFrame Int (Array Style)

infix 6 Prop as :

infix 6 Node as :-

infix 6 KeyFrame as :>



className :: Array Style -> Result
className styles = { name, output }
  where
    scope = toScope styles
    name = toHash scope
    output = replaceToken ("." <> name) scope



keyframes :: Array KeyFrame -> Result
keyframes keyframes' = { name, output }
  where
    keyFrameStr (KeyFrame percentage styles) =
      bracket (show percentage <> "%") $ unsafePropStr styles
    scope = F.fold $ map keyFrameStr keyframes'
    name = toHash scope
    output = bracket ("@keyframes " <> name) scope



media :: String -> Array String -> String
media key strings = bracket ("@media " <> key) $ F.fold strings



css :: String -> Array Style -> String
css key styles = bracket key $ unsafePropStr styles



token :: String
token = "&"



tokenPattern :: Pattern
tokenPattern = Pattern token



replaceToken :: String -> String -> String
replaceToken instead target =
  replaceAll tokenPattern (Replacement instead) target



interpolate :: String -> String -> String
interpolate parent child =
  if contains tokenPattern child
    then replaceToken parent child
    else parent <> " " <> child



walk :: String -> Style -> State (S.StrMap String) Unit
walk parent (Prop key value) =
  modify $ S.alter push parent
    where
      push Nothing = Just $ property key value
      push (Just s) = Just $ s <> property key value

walk parent (Node child styles) =
  F.for_ styles $ walk $ interpolate parent child



toScope :: Array Style -> String
toScope styles = S.fold cssify "" styleMap
  where
    styleMap = flip execState S.empty $ F.for_ styles $ walk token
    cssify acm key str = acm <> bracket key str



toHash :: String -> String
toHash str = toStringAs base36 $ zshr seed 0
  where
    culc char value = xor (value * 33) (toCharCode char)
    seed = F.foldr culc 5381 $ toCharArray str



unsafePropStr :: Array Style -> String
unsafePropStr styles = F.fold $ map toStr styles
  where
    toStr = unsafePartial \(Prop key value) -> property key value



property :: String -> String -> String
property key value = key <> ":" <> value <> ";"



bracket :: String -> String -> String
bracket key str = key <> "{" <> str <> "}"
