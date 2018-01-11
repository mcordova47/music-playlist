module Routes
    exposing
        ( Route(..)
        , enterLocation
        , parseLocation
        , url
        )

import UrlParser exposing ((</>))
import Navigation exposing (Location)
import Songs exposing (Song)


type Route
    = Home
    | SongView String


enterLocation : Location -> Song -> Cmd msg
enterLocation location song =
    location
        |> UrlParser.parseHash route
        |> redirect song


route : UrlParser.Parser (Route -> a) a
route =
    UrlParser.oneOf
        [ UrlParser.map Home UrlParser.top
        , UrlParser.map SongView (UrlParser.s "song" </> UrlParser.string)
        ]


parseLocation : Location -> Maybe Route
parseLocation =
    UrlParser.parseHash route


redirect : Song -> Maybe Route -> Cmd msg
redirect song route =
    case route of
        Just Home ->
            Navigation.modifyUrl ("#/song/" ++ song.video)

        Just (SongView video) ->
            Navigation.modifyUrl ("#/song/" ++ video)

        _ ->
            Cmd.none


url : Route -> String
url route =
    case route of
        Home ->
            ""

        SongView video ->
            "#/song/" ++ video
