module Requests exposing (songs)

import Http exposing (Request)
import Json.Decode as Decode
    exposing
        ( Decoder
        , at
        , list
        , string
        , int
        , succeed
        , fail
        )
import Songs exposing (Song)


songs : Bool -> Request Songs.Model
songs dev =
    Http.get (songUrl dev) songListDecoder


songUrl : Bool -> String
songUrl dev =
    if dev then
        "/api/songs/"
    else
        "https://music-playlist-191702.appspot.com/api/songs/"


songListDecoder : Decoder Songs.Model
songListDecoder =
    list songDecoder
        |> Decode.andThen fromList


songDecoder : Decoder Song
songDecoder =
    Decode.map6 Song
        (at [ "fields", "video" ] string)
        (at [ "fields", "title" ] string)
        (at [ "fields", "artist" ] string)
        (at [ "fields", "year" ] int)
        (at [ "fields", "album" ] string)
        (at [ "fields", "notes" ] string)


fromList : List Song -> Decoder Songs.Model
fromList list =
    case Songs.fromList list of
        Nothing ->
            fail "Expected nonempty list, but received empty list"

        Just xs ->
            succeed xs
