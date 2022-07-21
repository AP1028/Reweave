module Lib.CoreEngine.GameLayer.Display exposing (..)

import Array
import Base exposing (GlobalData)
import Canvas exposing (Renderable, group)
import Lib.CoreEngine.Base exposing (GameGlobalData)
import Lib.CoreEngine.Camera.Position exposing (getPositionUnderCamera)
import Lib.CoreEngine.GameComponent.ComponentHandler exposing (genView)
import Lib.CoreEngine.GameLayer.Base exposing (GameLayerDepth(..))
import Lib.CoreEngine.GameLayer.Common exposing (Model, kineticCalc, searchUIDGC)
import Lib.CoreEngine.Physics.NaiveCollision exposing (getBoxPos)
import Lib.Render.Chartlet exposing (renderChartletsBehindActor, renderChartletsBehindSolids, renderChartletsFront)
import Lib.Render.Energy exposing (renderEnergyPoint)
import Lib.Render.Solid exposing (renderSolids)


view : ( Model, Int ) -> GameGlobalData -> GlobalData -> Renderable
view ( model, ot ) ggd gd =
    let
        allobjs =
            Array.push model.player model.actors

        t =
            if ggd.ingamepause then
                0

            else
                ot

        selected =
            ggd.selectobj
    in
    group []
        [ renderChartletsBehindActor model ggd gd
        , genView ggd gd t allobjs
        , if selected > 0 then
            let
                obj =
                    searchUIDGC selected allobjs
            in
            case Array.get obj allobjs of
                Just tk ->
                    let
                        ( p1, p2 ) =
                            getBoxPos tk.data.position tk.data.simplecheck
                    in
                    renderEnergyPoint t gd (kineticCalc tk.data.mass tk.data.velocity) ( getPositionUnderCamera p1 ggd, getPositionUnderCamera p2 ggd )

                _ ->
                    group [] []

          else
            group [] []
        , renderChartletsBehindSolids model ggd gd
        , renderSolids ggd gd
        , renderChartletsFront model ggd gd
        ]
