module Lib.CoreEngine.GameComponents.Bullet.Model exposing (..)

import Base exposing (GlobalData, Msg(..))
import Dict
import Lib.Component.Base exposing (DefinedTypes(..))
import Lib.CoreEngine.Base exposing (GameGlobalData)
import Lib.CoreEngine.GameComponent.Base exposing (Box, Data, GameComponentMsgType(..), GameComponentTMsg(..), LifeStatus(..))
import Lib.CoreEngine.Physics.SolidCollision exposing (canMove)
import Lib.DefinedTypes.Parser exposing (dgetfloat)
import Math.Vector2 exposing (vec2)


initData : Data
initData =
    { status = Alive
    , position = ( 900, 1850 )
    , velocity = ( -50, 0 )
    , mass = 5
    , acceleration = ( 0, 0 )
    , simplecheck = simplecheckBox
    , collisionbox = [ collisionBox ]
    , extra = Dict.empty
    , uid = 50
    }


collisionBox : Box
collisionBox =
    { name = "col"
    , offsetX = 0
    , offsetY = 0
    , width = 30
    , height = 30
    }


simplecheckBox : Box
simplecheckBox =
    { name = "sp"
    , offsetX = 0
    , offsetY = 0
    , width = 30
    , height = 30
    }


initModel : Int -> GameComponentTMsg -> Data
initModel _ gcm =
    case gcm of
        GameBulletInit info ->
            { status = Alive
            , position = info.initPosition
            , velocity = info.initVelocity
            , mass = 5
            , acceleration = ( 0, 0 )
            , simplecheck = simplecheckBox
            , collisionbox = [ collisionBox ]
            , extra =
                Dict.fromList
                    [ ( "radius", CDFloat info.radius )
                    ]
            , uid = info.uid
            }

        _ ->
            initData


updateModel : Msg -> GameComponentTMsg -> GameGlobalData -> GlobalData -> ( Data, Int ) -> ( Data, List GameComponentMsgType, GameGlobalData )
updateModel msg gct ggd gd ( d, t ) =
    case gct of
        GameInterCollisionMsg _ pd _ ->
            ( { d | status = Dead t }, [ GameActorUidMsg pd.uid (GameStringMsg "die") ], ggd )

        _ ->
            let
                r =
                    dgetfloat d.extra "radius"

                ( vx, vy ) =
                    d.velocity

                ( x, y ) =
                    d.position
            in
            if (vx < 0 && not (canMove d ggd (vec2 -1 0))) || (vx > 0 && not (canMove d ggd (vec2 1 0))) then
                ( { d | status = Dead t }, [], ggd )

            else
                ( { d | position = ( x + ceiling (vx / 1000), y + ceiling (vy / 1000) ) }, [], ggd )


queryModel : String -> ( Data, Int ) -> GameComponentTMsg
queryModel _ _ =
    NullGameComponentMsg
