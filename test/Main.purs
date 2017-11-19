module Test.Main where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import PureStyle (StyleSheet, createStyleSheet, getStyle, registerStyle)
import Test.Assert (assert, ASSERT)



main :: forall e. Eff (assert :: ASSERT, console :: CONSOLE | e) Unit
main = do
  assert $ sampleClass == "z66dqm"
  assert $ sampleKeyframes == "25sc03"
  assert $ sampleClassNameWithMedia == "2aok7f"
  log $ getStyle sheet



sheet :: StyleSheet
sheet = createStyleSheet



sampleClass :: String
sampleClass = registerStyle sheet
  """
  .& {
    width: 100px;
    height: 100px;
  }
  .&:hover {
    width: 100px;
    height: 100px;
  }
  .&:hover .selected {
    color: blue;
  }
  """



sampleKeyframes :: String
sampleKeyframes = registerStyle sheet
  """
  @keyframes & {
    0% {
      width: 100px;
    }
    50% {
      width: 150px;
    }
    100% {
      width: 200px;
    }
  }
  """



sampleCSS :: Unit
sampleCSS = const unit $ registerStyle sheet
  """
  html, body {
    height: 100%;
  }
  """



sampleClassNameWithMedia :: String
sampleClassNameWithMedia = registerStyle sheet
  """
  @media (max-width: 700px) {
    .& {
      background-color: yellow;
    }
  }
  @media (min-width: 700px) {
    .& {
      background-color: blue;
    }
  }
  """
