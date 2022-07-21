module Lib.CoreEngine.GameComponents.Spike.Base exposing (..)


type alias SpikeInit =
    { initPosition : ( Int, Int )
    , direction : SpikeDirection
    , spikesnum : Int
    , uid : Int
    }


type SpikeDirection
    = HorUp
    | HorDown
    | VerRight
    | VerLeft