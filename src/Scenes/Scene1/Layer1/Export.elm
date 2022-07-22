module Scenes.Scene1.Layer1.Export exposing (..)

{-| This is the doc for this module

@docs Data

@docs nullData

@docs layer

-}

import Lib.Layer.Base exposing (..)
import Scenes.Scene1.Layer1.Common exposing (ModelX)
import Scenes.Scene1.Layer1.Display exposing (dview)
import Scenes.Scene1.Layer1.Models exposing (initModel, updateModel)
import Scenes.Scene1.LayerBase exposing (CommonData)


{-| Data
-}
type alias Data =
    ModelX


{-| nullData
-}
nullData : Data
nullData =
    { s = 0
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
