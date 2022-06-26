module Scenes.Scene1.Model exposing (..)

import Base exposing (GlobalData, Msg)
import Html exposing (Html)
import Lib.Layer.Base exposing (LayerMsg(..))
import Lib.Layer.LayerHandler exposing (updateLayer, viewLayer)
import Lib.Scene.Base exposing (SceneMsg(..), SceneOutputMsg(..))
import Scenes.Scene1.Common exposing (XModel)
import Scenes.Scene1.Layer1.Export as L1
import Scenes.Scene1.Layer1.Global as L1G


initModel : Int -> SceneMsg -> XModel
initModel t _ =
    let
        icd =
            { plt = 0
            }

        l1l =
            L1.layer

        l1ct =
            L1G.getLayerCT { l1l | data = L1.layer.init t icd }
    in
    { commonData = icd
    , layers = [ ( "Layer1", l1ct ) ]
    }


handleLayerMsg : LayerMsg -> ( XModel, Int ) -> ( XModel, SceneOutputMsg )
handleLayerMsg lmsg ( model, _ ) =
    case lmsg of
        LayerStringMsg str ->
            if str == "Restart" then
                ( model, ChangeScene ( NullSceneMsg, "Scene1" ) )

            else
                ( model, NullSceneOutputMsg )

        _ ->
            ( model, NullSceneOutputMsg )


updateModel : Msg -> ( XModel, Int ) -> ( XModel, SceneOutputMsg )
updateModel msg ( model, t ) =
    let
        ( newdata, newcd, msgs ) =
            updateLayer msg t model.commonData model.layers

        nmodel =
            { model | commonData = newcd, layers = newdata }

        ( newmodel, newso ) =
            List.foldl (\x ( y, _ ) -> handleLayerMsg x ( y, t )) ( nmodel, NullSceneOutputMsg ) msgs
    in
    ( newmodel, newso )


viewModel : ( XModel, Int ) -> GlobalData -> Html Msg
viewModel ( model, t ) gd =
    viewLayer gd t model.commonData model.layers
