module Scenes.Home.Layer1.Export exposing
    ( Data
    , nullData
    , layer
    )

{-| This is the doc for this module

@docs Data

@docs nullData

@docs layer

-}

import Lib.Layer.Base exposing (..)
import Scenes.Home.Layer1.Common exposing (ModelX)
import Scenes.Home.Layer1.Display exposing (dview)
import Scenes.Home.Layer1.Models exposing (..)
import Scenes.Home.LayerBase exposing (CommonData)


{-| Data
-}
type alias Data =
    ModelX


{-| nullData
-}
nullData : Data
nullData =
    { start = initButton "Start" ( 960, 40 ) 15 10
    }


{-| layer
-}
layer : Layer CommonData Data
layer =
    { data = nullData
    , init = initModel
    , update = updateModel
    , view = dview
    }
