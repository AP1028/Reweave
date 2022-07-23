module Components.Menu.Settings.Play.Export exposing
    ( component
    , initComponent
    )

{-| This is the doc for this module

@docs component

@docs initComponent

-}

import Components.Menu.Settings.Play.Play exposing (initMap, updateMap, viewMap)
import Lib.Component.Base exposing (Component, ComponentTMsg(..))


{-| component
-}
component : Component
component =
    { name = "Play"
    , data = initMap 0 NullComponentMsg
    , init = initMap
    , update = updateMap
    , view = viewMap
    , query = \_ _ -> NullComponentMsg
    }


{-| initComponent
-}
initComponent : Int -> ComponentTMsg -> Component
initComponent t ct =
    { component | data = component.init t ct }