module Lib.Layer.Base exposing (..)

import Base exposing (GlobalData, Msg)
import Canvas exposing (Renderable)
import Lib.Audio.Base exposing (AudioOption)


type alias Layer a b =
    --- b is the layer data, a is the common data that shares between layers
    { data : b
    , init : Int -> a -> b
    , update : Msg -> LayerMsg -> ( b, Int ) -> a -> ( b, a, ( LayerTarget, LayerMsg ) )
    , view : ( b, Int ) -> a -> GlobalData -> Renderable
    }


type LayerMsg
    = LayerStringMsg String
    | LayerIntMsg Int
    | LayerSoundMsg String String AudioOption
    | LayerStopSoundMsg String
    | NullLayerMsg


type LayerTarget
    = LayerParentScene
    | LayerName String
    | NullLayerTarget



--- LayerMsg is the message that sends to outer layer (scene)