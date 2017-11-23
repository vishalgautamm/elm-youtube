port module Main exposing (..)

import Html exposing (Html)
import Model exposing (Model, init)
import Update exposing (update, subscriptions, Msg(..), check)
import View exposing (view)


main : Program Never Model Msg
main =
    Html.program
        { init = ( init, check init.word )
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
