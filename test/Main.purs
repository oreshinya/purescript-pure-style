module Test.Main where

import Prelude

import PureStyle (StyleSheet, createStyleSheet, getStyle, registerStyle)
import Effect (Effect)
import Test.Assert (assert)

main :: Effect Unit
main = do
  assert $ sampleClass == "pz66dqm"
  assert $ sampleClass2 == "pz66dqm"
  assert $ sampleKeyframes == "p25sc03"
  assert $ sampleClassNameWithMedia == "p2aok7f"
  assert $ getStyle sheet ==
    "@keyframes p25sc03 { 0% { width: 100px; } 50% { width: 150px; } 100% { width: 200px; } }@media (max-width: 700px) { .p2aok7f { background-color: yellow; } } @media (min-width: 700px) { .p2aok7f { background-color: blue; } }.pz66dqm { width: 100px; height: 100px; } .pz66dqm:hover { width: 100px; height: 100px; } .pz66dqm:hover .selected { color: blue; }html, body { height: 100%; }"

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

sampleClass2 :: String
sampleClass2 = registerStyle sheet
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
