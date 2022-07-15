module Lib.CoreEngine.GameLayer.Common exposing (..)

import Array exposing (Array)
import Base exposing (GlobalData)
import Canvas exposing (Renderable)
import Lib.CoreEngine.Base exposing (GameGlobalData)
import Lib.CoreEngine.GameComponent.Base exposing (GameComponent)


type alias Model =
    { player : GameComponent
    , actors : Array GameComponent
    , chartlets : List (GlobalData -> GameGlobalData -> Renderable)
    }
