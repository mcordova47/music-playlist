module Routes
    exposing
        ( Route(..)
        , enterLocation
        , parseLocation
        , url
        )

import UrlParser exposing ((</>))
import Navigation exposing (Location)


type Route
    = Home
    | SongView String


enterLocation : Location -> Cmd msg
enterLocation =
    redirect << UrlParser.parseHash route


route : UrlParser.Parser (Route -> a) a
route =
    UrlParser.oneOf
        [ UrlParser.map Home UrlParser.top
        , UrlParser.map SongView (UrlParser.s "song" </> UrlParser.string)
        ]


parseLocation : Location -> Maybe Route
parseLocation =
    UrlParser.parseHash route


redirect : Maybe Route -> Cmd msg
redirect route =
    case route of
        Just Home ->
            Navigation.modifyUrl "#/song/P_Fx1yq3A8M"

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
