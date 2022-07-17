module Lib.CoreEngine.BackgroundLayer.Model exposing (..)

import Base exposing (GlobalData, Msg)
import Canvas exposing (group)
import Lib.CoreEngine.BackgroundLayer.Common exposing (Model)
import Lib.CoreEngine.Base exposing (GameGlobalData)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget)


initModel : Int -> LayerMsg -> GameGlobalData -> Model
initModel _ lm _ =
    case lm of
        LayerCTMsg f ->
            { render = f.timeseries }

        _ ->
            { render = \_ _ _ -> group [] [] }


updateModel : Msg -> GlobalData -> LayerMsg -> ( Model, Int ) -> GameGlobalData -> ( ( Model, GameGlobalData, List ( LayerTarget, LayerMsg ) ), GlobalData )
updateModel _ gd _ ( model, _ ) ggd =
    ( ( model, ggd, [] ), gd )
