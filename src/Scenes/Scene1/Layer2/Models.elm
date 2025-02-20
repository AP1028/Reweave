module Scenes.Scene1.Layer2.Models exposing
    ( initModel
    , updateModel
    )

{-| This is the doc for this module

@docs initModel

@docs updateModel

-}

--- Init a model, and update it

import Array
import Base exposing (..)
import Components.Menu.Export as ComMenuE
import Lib.Audio.Base exposing (AudioOption(..))
import Lib.Component.Base exposing (ComponentTMsg(..))
import Lib.Component.ComponentHandler exposing (updateSingleComponent)
import Lib.Layer.Base exposing (LayerMsg(..), LayerTarget(..))
import Lib.Scene.Base exposing (..)
import Scenes.Scene1.Layer2.Common exposing (..)
import Scenes.Scene1.LayerBase exposing (CommonData)


{-| initModel
-}
initModel : Int -> LayerMsg -> CommonData -> ModelX
initModel _ _ _ =
    { components = [ ComMenuE.initComponent 0 NullComponentMsg ]
    }


{-| updateModel
-}
updateModel : Msg -> GlobalData -> LayerMsg -> SModel -> CommonData -> ( ( ModelX, CommonData, List ( LayerTarget, LayerMsg ) ), GlobalData )
updateModel msg gd _ ( model, t ) cd =
    case msg of
        Tick _ ->
            let
                components =
                    model.components

                ( newComponents, _, newGlobalData ) =
                    if t == 100 then
                        updateSingleComponent msg (ComponentIntMsg 50) gd t 0 (Array.fromList components)

                    else
                        updateSingleComponent msg NullComponentMsg gd t 0 (Array.fromList components)
            in
            ( ( { model | components = Array.toList newComponents }, cd, [] ), newGlobalData )

        MouseDown _ _ ->
            let
                components =
                    model.components

                ( newComponents, _, newGlobalData ) =
                    updateSingleComponent msg NullComponentMsg gd t 0 (Array.fromList components)
            in
            ( ( { model | components = Array.toList newComponents }, cd, [] ), newGlobalData )

        _ ->
            ( ( model, cd, [] ), gd )



-- case msg of
--     KeyDown _ ->
--         ( model, cd, ( LayerParentScene, LayerSoundMsg "se" "./assets/audio/Eaten.ogg" AOnce ) )
--         -- ( model, cd, ( LayerParentScene, LayerStopSoundMsg "bgm" ) )
--     _ ->
--         if t == 200 then
--             ( model, cd, ( LayerParentScene, LayerSoundMsg "bgm" "./assets/audio/main.ogg" ALoop ) )
--         else
