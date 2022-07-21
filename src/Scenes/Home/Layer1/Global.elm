module Scenes.Home.Layer1.Global exposing (..)

import Base exposing (GlobalData, Msg)
import Canvas exposing (Renderable)
import Lib.Layer.Base exposing (..)
import Scenes.Home.Layer1.Export exposing (Data, nullData)
import Scenes.Home.LayerBase exposing (CommonData)
import Scenes.Home.LayerSettings exposing (..)


dToCT : Data -> LayerDataType
dToCT data =
    Layer1Data data


ctTod : LayerDataType -> Data
ctTod ldt =
    case ldt of
        Layer1Data x ->
            x

        _ ->
            nullData


getLayerCT : Layer CommonData Data -> LayerCT
getLayerCT layer =
    let
        init : Int -> LayerMsg -> CommonData -> LayerDataType
        init t lm cd =
            dToCT (layer.init t lm cd)

        update : Msg -> GlobalData -> LayerMsg -> ( LayerDataType, Int ) -> CommonData -> ( ( LayerDataType, CommonData, List ( LayerTarget, LayerMsg ) ), GlobalData )
        update m gd lm ( ldt, t ) cd =
            let
                ( ( rldt, rcd, ltm ), newgd ) =
                    layer.update m gd lm ( ctTod ldt, t ) cd
            in
            ( ( dToCT rldt, rcd, ltm ), newgd )

        view : ( LayerDataType, Int ) -> CommonData -> GlobalData -> Renderable
        view ( ldt, t ) cd gd =
            layer.view ( ctTod ldt, t ) cd gd
    in
    Layer (dToCT layer.data) init update view