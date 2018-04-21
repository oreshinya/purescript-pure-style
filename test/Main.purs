module Test.Main where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import PureStyle (Style, style, name, output)
import Test.Assert (assert, ASSERT)



main :: forall e. Eff (assert :: ASSERT, console :: CONSOLE | e) Unit
main = do
  assert $ name sampleStyle == "pz66dqm"
  assert $ name sampleKeyframes == "p25sc03"
  assert $ name sampleStyleWithMedia == "p2aok7f"
  log $ output sampleStyle
  log $ output sampleKeyframes
  log $ output sampleBaseStyle
  log $ output sampleStyleWithMedia



sampleStyle :: Style
sampleStyle = style
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



sampleKeyframes :: Style
sampleKeyframes = style
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



sampleBaseStyle :: Style
sampleBaseStyle = style
  """
  html, body {
    height: 100%;
  }
  """



sampleStyleWithMedia :: Style
sampleStyleWithMedia = style
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
