port module Ports exposing (..)

import Json.Decode exposing (Value)


port youtubeStateChange : (Value -> msg) -> Sub msg
