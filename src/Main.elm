port module Main exposing (main)

{-| This is the doc for this module

@docs main

-}

import Audio exposing (AudioCmd, AudioData)
import Base exposing (..)
import Browser.Events exposing (onKeyDown, onKeyUp, onMouseDown, onMouseMove, onResize)
import Canvas
import Canvas.Settings exposing (fill)
import Color
import Common exposing (..)
import Dict
import Html exposing (Html)
import Html.Attributes exposing (style)
import Json.Decode as Decode
import Json.Encode as Encode
import Lib.Audio.Audio exposing (loadAudio, stopAudio)
import Lib.Coordinate.Coordinates exposing (fromMouseToReal, getStartPoint, maxHandW)
import Lib.Layer.Base exposing (LayerMsg(..))
import Lib.LocalStorage.LocalStorage exposing (decodeLSInfo, encodeLSInfo)
import Lib.Resources.Base exposing (getTexture, saveSprite)
import Lib.Scene.Base exposing (..)
import Lib.Scene.SceneLoader exposing (getCurrentScene, loadSceneByName)
import Scenes.SceneSettings exposing (..)
import Task
import Time


port audioPortToJS : Encode.Value -> Cmd msg


port sendInfo : String -> Cmd msg


port audioPortFromJS : (Decode.Value -> msg) -> Sub msg


{-| initModel
-}
initModel : Model
initModel =
    { currentData = NullSceneData
    , currentScene = nullSceneCT
    , currentGlobalData = initGlobalData
    , time = 0
    , audiorepo = []
    }


{-| main
-}
main : Program Flags (Audio.Model Msg Model) (Audio.Msg Msg)
main =
    Audio.elementWithAudio
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , audio = audio
        , audioPort = { toJS = audioPortToJS, fromJS = audioPortFromJS }
        }



--INIT


{-| init
-}
init : Flags -> ( Model, Cmd Msg, AudioCmd Msg )
init flags =
    let
        ms =
            loadSceneByName initModel "Level4" NullSceneMsg

        oldgd =
            ms.currentGlobalData

        ( gw, gh ) =
            maxHandW ( flags.windowWidth, flags.windowHeight )

        ( fl, ft ) =
            getStartPoint ( flags.windowWidth, flags.windowHeight )

        newgd =
            { oldgd | localstorage = decodeLSInfo flags.info, browserViewPort = ( flags.windowWidth, flags.windowHeight ), realWidth = gw, realHeight = gh, startLeft = fl, startTop = ft }
    in
    ( { ms | currentGlobalData = newgd }, Cmd.none, Audio.cmdNone )



--UPDATE


{-| update
-}
update : AudioData -> Msg -> Model -> ( Model, Cmd Msg, AudioCmd Msg )
update _ msg model =
    case msg of
        TextureLoaded _ Nothing ->
            ( model, Cmd.none, Audio.cmdNone )

        TextureLoaded name (Just t) ->
            let
                oldsprites =
                    model.currentGlobalData.sprites

                newsp =
                    saveSprite oldsprites name t

                oldgd =
                    model.currentGlobalData

                newgd =
                    { oldgd | sprites = newsp }
            in
            ( { model | currentGlobalData = newgd }, Cmd.none, Audio.cmdNone )

        SoundLoaded name opt result ->
            case result of
                Ok sound ->
                    ( model
                    , Task.perform (PlaySoundGotTime name opt sound) Time.now
                    , Audio.cmdNone
                    )

                Err _ ->
                    ( model
                    , Cmd.none
                    , Audio.cmdNone
                    )

        PlaySoundGotTime name opt sound t ->
            ( { model | audiorepo = loadAudio model.audiorepo name sound opt t }, Cmd.none, Audio.cmdNone )

        NewWindowSize t ->
            let
                oldgd =
                    model.currentGlobalData

                ( gw, gh ) =
                    maxHandW t

                ( fl, ft ) =
                    getStartPoint t

                newgd =
                    { oldgd | browserViewPort = t, realWidth = gw, realHeight = gh, startLeft = fl, startTop = ft }
            in
            ( { model | currentGlobalData = newgd }, Cmd.none, Audio.cmdNone )

        MouseMove ( px, py ) ->
            let
                curgd =
                    model.currentGlobalData

                mp =
                    fromMouseToReal curgd ( toFloat px, toFloat py )
            in
            ( { model | currentGlobalData = { curgd | mousePos = mp } }, Cmd.none, Audio.cmdNone )

        _ ->
            if Dict.isEmpty model.currentGlobalData.sprites then
                ( model, Cmd.none, Audio.cmdNone )

            else
                let
                    cs =
                        getCurrentScene model

                    cd =
                        model.currentData

                    cm =
                        ( cd, model.time )

                    ( sdt, som, newgd ) =
                        cs.update msg model.currentGlobalData cm

                    ntmodel =
                        { model | time = model.time + 1, currentGlobalData = newgd }

                    tmodel =
                        case msg of
                            Tick _ ->
                                ntmodel

                            _ ->
                                { model | currentGlobalData = newgd }

                    bnewmodel =
                        { tmodel | currentData = sdt, currentGlobalData = newgd }
                in
                case som of
                    SOChangeScene ( tm, s ) ->
                        --- Load new scene
                        ( loadSceneByName tmodel s tm
                            |> resetSceneStartTime
                        , sendInfo (encodeLSInfo tmodel.currentGlobalData.localstorage)
                        , Audio.cmdNone
                        )

                    SOPlayAudio name path opt ->
                        ( bnewmodel, Cmd.none, Audio.loadAudio (SoundLoaded name opt) path )

                    SOSetVolume s ->
                        let
                            oldgd =
                                bnewmodel.currentGlobalData

                            newgd2 =
                                { oldgd | audioVolume = s }
                        in
                        ( { bnewmodel | currentGlobalData = newgd2 }, Cmd.none, Audio.cmdNone )

                    SOStopAudio name ->
                        ( { bnewmodel | audiorepo = stopAudio bnewmodel.audiorepo name }, Cmd.none, Audio.cmdNone )

                    _ ->
                        ( updateSceneStartTime bnewmodel, sendInfo (encodeLSInfo tmodel.currentGlobalData.localstorage), Audio.cmdNone )


{-| subscriptions
-}
subscriptions : AudioData -> Model -> Sub Msg
subscriptions _ _ =
    Sub.batch
        [ Time.every 15 Tick --- Slow down the fps
        , onKeyDown (Decode.map (\x -> KeyDown x) (Decode.field "keyCode" Decode.int))
        , onKeyUp (Decode.map (\x -> KeyUp x) (Decode.field "keyCode" Decode.int))
        , onResize (\w h -> NewWindowSize ( w, h ))
        , onMouseDown (Decode.map3 (\b x y -> MouseDown b ( x, y )) (Decode.field "button" Decode.int) (Decode.field "clientX" Decode.float) (Decode.field "clientY" Decode.float))
        , onMouseMove (Decode.map2 (\x y -> MouseMove ( x, y )) (Decode.field "clientX" Decode.int) (Decode.field "clientY" Decode.int))
        ]


{-| view
-}
view : AudioData -> Model -> Html Msg
view _ model =
    let
        cursor =
            if model.currentGlobalData.visualaid then
                "crosshair"

            else
                "auto"

        -- case model.currentGlobalData.cursor of
        --     CursorNormal ->
        --         "crosshair"
        --     CursorNone ->
        --         "none"
    in
    Canvas.toHtmlWith
        { width = model.currentGlobalData.realWidth
        , height = model.currentGlobalData.realHeight
        , textures = getTexture
        }
        [ style "left" (String.fromFloat model.currentGlobalData.startLeft)
        , style "top" (String.fromFloat model.currentGlobalData.startTop)
        , style "position" "fixed"
        , style "cursor" cursor
        ]
        [ Canvas.shapes [ fill Color.white ] [ Canvas.rect ( 0, 0 ) (toFloat model.currentGlobalData.realWidth) (toFloat model.currentGlobalData.realHeight) ]
        , (getCurrentScene model).view ( model.currentData, model.time ) model.currentGlobalData
        ]
