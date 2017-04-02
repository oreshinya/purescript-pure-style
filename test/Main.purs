module Test.Main where

import Prelude
import Control.Monad.Eff (Eff)
import Test.Assert (assert, ASSERT)
import PureStyle ((:), (:-), (:>), className, keyframes, media, css)

main :: forall e. Eff (assert :: ASSERT | e) Unit
main = do
  assert $ sampleClass.output == ".cnfpbt{width:100px;height:100px;}.cnfpbt:hover{width:200px;height:200px;}.cnfpbt:hover:disabled{color:red;}.cnfpbt:hover .selected{color:blue;}"
  assert $ sampleKeyframes.output == "@keyframes 1n9qlcq{0%{width:100px;}50%{width:150px;}100%{width:200px;}}"
  assert $ sampleCss == "html, body{height:100%;}"
  assert $ sampleMedia == "@media screen{html, body{height:100%;}.cnfpbt{width:100px;height:100px;}.cnfpbt:hover{width:200px;height:200px;}.cnfpbt:hover:disabled{color:red;}.cnfpbt:hover .selected{color:blue;}@keyframes 1n9qlcq{0%{width:100px;}50%{width:150px;}100%{width:200px;}}}"
  where
    sampleClass = className
      [ "width" : "100px"
      , "height" : "100px"
      , "&:hover" :-
          [ "width" : "200px"
          , "height" : "200px"
          , "&:disabled" :- [ "color" : "red" ]
          , ".selected" :- [ "color" : "blue" ]
          ]
      ]

    sampleKeyframes = keyframes
      [ 0 :> [ "width" : "100px" ]
      , 50 :> [ "width" : "150px" ]
      , 100 :> [ "width" : "200px" ]
      ]

    sampleCss = css "html, body" [ "height" : "100%" ]

    sampleMedia = media "screen"
      [ sampleCss
      , sampleClass.output
      , sampleKeyframes.output
      ]
