module Lib.CoreEngine.LayerSettings exposing (..)

import Lib.CoreEngine.BackgroundLayer.Export as BGL
import Lib.CoreEngine.Base exposing (GameGloablData)
import Lib.CoreEngine.FrontgroundLayer.Export as FGL
import Lib.Layer.Base exposing (Layer)


type LayerDataType
    = FrontgroundData FGL.Data
    | BackgroundData BGL.Data
    | NullLayerData


type alias LayerCT =
    Layer GameGloablData LayerDataType
