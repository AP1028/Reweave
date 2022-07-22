module Lib.CoreEngine.GameComponents.GoombaEmitter.Export exposing (..)

{-| This is the doc for this module

@docs gameComponent

-}

import Lib.CoreEngine.GameComponent.Base exposing (GameComponent)
import Lib.CoreEngine.GameComponents.GoombaEmitter.Display exposing (view)
import Lib.CoreEngine.GameComponents.GoombaEmitter.Model exposing (initData, initModel, updateModel)


{-| gameComponent
-}
gameComponent : GameComponent
gameComponent =
    { name = "goombaemitter"
    , data = initData
    , init = initModel
    , update = updateModel
    , view = view
    }
