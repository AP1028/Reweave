module Lib.CoreEngine.GameComponents.Bird.Display exposing (view)

{-| This is the doc for this module

@docs view

-}

import Base exposing (GlobalData)
import Canvas exposing (Renderable, group)
import Canvas.Settings.Advanced exposing (alpha)
import Lib.CoreEngine.Base exposing (GameGlobalData)
import Lib.CoreEngine.Camera.Position exposing (getPositionUnderCamera)
import Lib.CoreEngine.GameComponent.Base exposing (Data, LifeStatus(..))
import Lib.Render.Render exposing (renderSprite)


{-| view
-}
view : ( Data, Int ) -> GameGlobalData -> GlobalData -> List ( Renderable, Int )
view ( d, t ) ggd gd =
    [ ( group []
            [ renderSprite
                gd
                [ case d.status of
                    Dead ct ->
                        if t - ct >= 100 || t < 0 then
                            alpha 0

                        else
                            alpha (toFloat (100 - t + ct) / 100)

                    _ ->
                        alpha 1
                ]
                (getPositionUnderCamera d.position ggd)
                ( d.simplecheck.width, d.simplecheck.height )
                "bird"
            ]
      , 0
      )
    ]
