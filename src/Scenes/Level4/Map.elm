module Scenes.Level4.Map exposing (..)

import Array2D
import Lib.Map.Poly exposing (buildrect, buildrectT)


sds : Array2D.Array2D Int
sds =
    Array2D.repeat 200 70 0


mymap : Array2D.Array2D Int
mymap =
    sds
        |> buildrect ( 0, 0 ) ( 1, 70 ) 1
        |> buildrect ( 0, 68 ) ( 200, 2 ) 1
        |> buildrect ( 20, 65 ) ( 3, 3 ) 1
        |> buildrect ( 23, 62 ) ( 3, 3 ) 1
        |> buildrect ( 26, 59 ) ( 1, 3 ) 1
        |> buildrect ( 26, 61 ) ( 20, 1 ) 1
        |> buildrect ( 45, 59 ) ( 1, 3 ) 1
        |> buildrect ( 46, 62 ) ( 3, 3 ) 1
        |> buildrect ( 49, 65 ) ( 3, 3 ) 1
        |> buildrect ( 55, 52 ) ( 12, 1 ) 1
        |> buildrect ( 73, 55 ) ( 2, 1 ) 1
        |> buildrect ( 78, 51 ) ( 4, 1 ) 1
        |> buildrect ( 86, 58 ) ( 15, 5 ) 1
        --(15,10)
        |> buildrect ( 86, 49 ) ( 11, 9 ) 1
        |> buildrect ( 88, 45 ) ( 13, 4 ) 1
        -- pavilion
        |> buildrect ( 116, 56 ) ( 1, 12 ) 1
        |> buildrect ( 105, 55 ) ( 12, 1 ) 1
        |> buildrect ( 105, 54 ) ( 1, 1 ) 1
        |> buildrect ( 116, 54 ) ( 1, 1 ) 1
        |> buildrect ( 117, 51 ) ( 3, 3 ) 1
        |> buildrect ( 120, 50 ) ( 15, 1 ) 1