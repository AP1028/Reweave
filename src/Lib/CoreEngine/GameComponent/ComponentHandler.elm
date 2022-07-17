module Lib.CoreEngine.GameComponent.ComponentHandler exposing (..)

import Array exposing (Array)
import Array.Extra
import Base exposing (GlobalData, Msg)
import Canvas exposing (Renderable, group)
import Lib.CoreEngine.Base exposing (GameGlobalData)
import Lib.CoreEngine.GameComponent.Base exposing (Data, GameComponent, GameComponentMsgType, GameComponentTMsg(..), LifeStatus(..))
import Lib.CoreEngine.Physics.NaiveCollision exposing (getBoxPos, judgeInCamera)


updateOneGameComponent : Msg -> GameComponentTMsg -> GameGlobalData -> GlobalData -> Int -> GameComponent -> ( GameComponent, List GameComponentMsgType, GameGlobalData )
updateOneGameComponent msg ct ggd gd t c =
    let
        ( newx, newmsg, newggd ) =
            c.update msg ct ggd gd ( c.data, t )
    in
    ( { c | data = newx }, newmsg, newggd )


updateSingleGameComponent : Msg -> GameComponentTMsg -> GameGlobalData -> GlobalData -> Int -> Int -> Array GameComponent -> ( Array GameComponent, List GameComponentMsgType, GameGlobalData )
updateSingleGameComponent msg ct ggd gd t n xs =
    case getGameComponent n xs of
        Just k ->
            let
                ( newx, newmsg, newggd ) =
                    k.update msg ct ggd gd ( k.data, t )
            in
            ( Array.set n { k | data = newx } xs, newmsg, newggd )

        Nothing ->
            ( xs, [], ggd )


genView : GameGlobalData -> GlobalData -> Int -> Array GameComponent -> Renderable
genView ggd gd t xs =
    let
        allrs =
            Array.foldl
                (\x als ->
                    case renderSingleObject t x ggd gd of
                        Just tr ->
                            tr ++ als

                        Nothing ->
                            als
                )
                []
                xs

        res =
            List.sortWith (\( _, a ) ( _, b ) -> compare a b) allrs
    in
    group [] (List.map (\( x, _ ) -> x) res)


renderSingleObject : Int -> GameComponent -> GameGlobalData -> GlobalData -> Maybe (List ( Renderable, Int ))
renderSingleObject t gc ggd gd =
    if judgeInCamera gc ggd then
        -- Should show
        Just (gc.view ( gc.data, t ) ggd gd)

    else
        Nothing


getGameComponent : Int -> Array GameComponent -> Maybe GameComponent
getGameComponent n xs =
    Array.get n xs


simpleUpdateAllGameComponent : Msg -> GameComponentTMsg -> GameGlobalData -> GlobalData -> Int -> Array GameComponent -> ( Array GameComponent, List GameComponentMsgType, GameGlobalData )
simpleUpdateAllGameComponent msg gct ggd gd t gcs =
    Array.foldl
        (\x ( a, c, b ) ->
            let
                ( nbj, nmsg, nggd ) =
                    updateOneGameComponent msg gct b gd t x
            in
            ( Array.push nbj a, c ++ nmsg, nggd )
        )
        ( Array.empty, [], ggd )
        gcs


isAlive : Data -> Bool
isAlive d =
    case d.status of
        Alive ->
            True

        _ ->
            False


sendManyMsgGameComponent : Msg -> List GameComponentTMsg -> GameGlobalData -> GlobalData -> Int -> Int -> Array GameComponent -> ( Array GameComponent, List GameComponentMsgType, GameGlobalData )
sendManyMsgGameComponent msg gcts ggd gd n t gcs =
    List.foldl
        (\x ( a, c, b ) ->
            let
                oldgc =
                    Array.get n a
            in
            case oldgc of
                Just ogc ->
                    let
                        ( nbj, nmsg, nggd ) =
                            updateOneGameComponent msg x b gd t ogc
                    in
                    ( Array.set n nbj a, c ++ nmsg, nggd )

                Nothing ->
                    ( a, c, b )
        )
        ( gcs, [], ggd )
        gcts


sendManyGameComponentMsg : Msg -> GameComponentTMsg -> GameGlobalData -> GlobalData -> List Int -> Int -> Array GameComponent -> ( Array GameComponent, List GameComponentMsgType, GameGlobalData )
sendManyGameComponentMsg msg gct ggd gd ns t gcs =
    List.foldl
        (\x ( a, c, b ) ->
            let
                oldgc =
                    Array.get x a
            in
            case oldgc of
                Just ogc ->
                    let
                        ( nbj, nmsg, nggd ) =
                            updateOneGameComponent msg gct b gd t ogc
                    in
                    ( Array.set x nbj a, c ++ nmsg, nggd )

                Nothing ->
                    ( a, c, b )
        )
        ( gcs, [], ggd )
        ns


splitPlayerObjs : Array GameComponent -> GameComponent -> ( GameComponent, Array GameComponent )
splitPlayerObjs gcs defaultplayer =
    let
        newplayer =
            Maybe.withDefault defaultplayer (Array.get (Array.length gcs - 1) gcs)
    in
    ( newplayer, Array.Extra.pop gcs )


initGameComponent : Int -> GameComponentTMsg -> GameComponent -> GameComponent
initGameComponent t gct gc =
    { gc | data = gc.init t gct }



-- TODO: Write recursive message transform system like layer


getGameComponentCenter : GameComponent -> ( Int, Int )
getGameComponentCenter gc =
    let
        d =
            gc.data

        ( ( x1, y1 ), ( x2, y2 ) ) =
            getBoxPos d.position d.simplecheck

        cx =
            (toFloat x1 + toFloat x2) / 2

        cy =
            (toFloat y1 + toFloat y2) / 2
    in
    ( floor cx, floor cy )
