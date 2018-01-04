module Main exposing (..)

import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import List.Extra as List
import Ports
import Navigation exposing (Location)
import UrlParser exposing ((</>))
import Markdown
import Songs exposing (Song)


-- MODEL


type alias Model =
    { previousSongs : List Song
    , currentSong : Song
    , nextSongs : List Song
    , drawerState : Maybe DrawerMode
    , autoplay : Bool
    }


type DrawerMode
    = Playlist
    | Artists (Maybe String)


type Route
    = Home
    | SongView String


route : UrlParser.Parser (Route -> a) a
route =
    UrlParser.oneOf
        [ UrlParser.map Home UrlParser.top
        , UrlParser.map SongView (UrlParser.s "song" </> UrlParser.string)
        ]


init : Location -> ( Model, Cmd Msg )
init location =
    ( { previousSongs = []
      , currentSong = Songs.currentSong
      , nextSongs = Songs.nextSongs
      , drawerState = Nothing
      , autoplay = False
      }
    , location
        |> UrlParser.parseHash route
        |> redirect
    )


redirect : Maybe Route -> Cmd Msg
redirect route =
    case route of
        Just Home ->
            Navigation.modifyUrl "#/song/P_Fx1yq3A8M"

        Just (SongView video) ->
            Navigation.modifyUrl ("#/song/" ++ video)

        _ ->
            Cmd.none



-- UPDATE


type Msg
    = PageUp
    | PageDown
    | CloseDrawer
    | OpenDrawer DrawerMode
    | SelectSong Song
    | SelectArtist String
    | YoutubeStateChange Int
    | ToggleAutoPlay
    | UrlChange Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PageUp ->
            let
                newModel =
                    pageUp model
            in
                ( newModel, setUrl newModel.currentSong )

        PageDown ->
            let
                newModel =
                    pageDown model
            in
                ( newModel, setUrl newModel.currentSong )

        CloseDrawer ->
            ( { model | drawerState = Nothing }, Cmd.none )

        OpenDrawer mode ->
            ( { model | drawerState = Just mode }, Cmd.none )

        SelectSong song ->
            ( selectSong model song, setUrl song )

        SelectArtist artist ->
            ( { model | drawerState = Just (Artists (Just artist)) }, Cmd.none )

        YoutubeStateChange state ->
            if state == 0 && model.autoplay then
                ( pageUp model, Cmd.none )
            else
                ( model, Cmd.none )

        ToggleAutoPlay ->
            ( { model | autoplay = not model.autoplay }, Cmd.none )

        UrlChange location ->
            let
                video =
                    location
                        |> UrlParser.parseHash route
                        |> parseVideo
                        |> Maybe.withDefault ""
            in
                ( maybeChangeSong model video, Cmd.none )


setUrl : Song -> Cmd Msg
setUrl song =
    Navigation.newUrl ("#/song/" ++ song.video)


parseVideo : Maybe Route -> Maybe String
parseVideo route =
    case route of
        Just (SongView video) ->
            Just video

        _ ->
            Nothing


maybeChangeSong : Model -> String -> Model
maybeChangeSong model video =
    if model.currentSong.video == video then
        model
    else
        selectSongById model video


selectSongById : Model -> String -> Model
selectSongById model video =
    let
        allSongs =
            sortedSongs model

        filteredSongs =
            List.filter ((==) video << .video) allSongs

        maybeSong =
            case filteredSongs of
                [] ->
                    Nothing

                song :: _ ->
                    Just song
    in
        maybeSong
            |> Maybe.map (selectSong model)
            |> Maybe.withDefault model


selectSong : Model -> Song -> Model
selectSong model song =
    let
        allSongs =
            sortedSongs model

        previousSongs =
            allSongs
                |> List.takeWhile ((/=) song)
                |> List.reverse

        nextSongs =
            allSongs
                |> List.reverse
                |> List.takeWhile ((/=) song)
                |> List.reverse
    in
        { model
            | previousSongs = previousSongs
            , currentSong = song
            , nextSongs = nextSongs
        }


pageUp : Model -> Model
pageUp model =
    case model.nextSongs of
        [] ->
            model

        next :: rest ->
            { model
                | previousSongs = model.currentSong :: model.previousSongs
                , currentSong = next
                , nextSongs = rest
            }


pageDown : Model -> Model
pageDown model =
    case model.previousSongs of
        [] ->
            model

        prev :: rest ->
            { model
                | previousSongs = rest
                , currentSong = prev
                , nextSongs = model.currentSong :: model.nextSongs
            }



-- VIEW


view : Model -> Html Msg
view model =
    Html.div
        [ Attributes.class "app-container" ]
        [ songView model.currentSong model.autoplay
        , navButton True
        , playAllButton model.autoplay
        , navigationView model
        ]


songView : Song -> Bool -> Html Msg
songView song autoplay =
    Html.div
        [ Attributes.class "song-view" ]
        [ Html.div
            [ Attributes.class "song-view__artist" ]
            [ Html.text song.artist ]
        , Html.div
            [ Attributes.class "song-view__title" ]
            [ Html.text song.title ]
        , Html.div
            [ Attributes.class "song-view__selector" ]
            [ Html.div
                [ Attributes.class "arrow"
                , Events.onClick PageDown
                ]
                [ Html.text "<" ]
            , Html.div
                [ Attributes.class "song-view__video" ]
                [ youtubeVideo song.video autoplay
                ]
            , Html.div
                [ Attributes.class "arrow"
                , Events.onClick PageUp
                ]
                [ Html.text ">" ]
            ]
        , Html.div
            [ Attributes.class "song-view__notes" ]
            [ Html.p []
                [ Markdown.toHtml [] song.notes ]
            ]
        ]


navigationView : Model -> Html Msg
navigationView model =
    Html.div
        [ Attributes.classList
            [ ( "navigation-view", True )
            , ( "navigation-view--open", drawerOpen model.drawerState )
            ]
        ]
        [ navViewHeader model.drawerState
        , navList model
        ]


navViewHeader : Maybe DrawerMode -> Html Msg
navViewHeader drawerState =
    Html.div
        [ Attributes.class "navigation-view__header" ]
        [ navButton False
        , Html.div
            [ Attributes.class "navigation-view__header__title" ]
            [ navTitle
            ]
        ]


navTitle : Html Msg
navTitle =
    Html.text "Artists"


artistList : Model -> List (Html Msg)
artistList model =
    sortedSongs model
        |> List.map .artist
        |> List.distinct
        |> List.sort
        |> List.map (artistLink model)


songList : Model -> List (Html Msg)
songList model =
    sortedSongs model
        |> List.map (songLinkMain model.currentSong)


listFunc : DrawerMode -> Model -> List (Html Msg)
listFunc drawerMode =
    case drawerMode of
        Playlist ->
            songList

        Artists _ ->
            artistList


navList : Model -> Html Msg
navList model =
    let
        listFn =
            model.drawerState
                |> Maybe.map listFunc
                |> Maybe.withDefault (\_ -> [])
    in
        Html.div
            [ Attributes.class "nav-list" ]
            (listFn model)


songLink : String -> Song -> Song -> Html Msg
songLink class currentSong song =
    Html.div
        [ Attributes.classList
            [ ( "nav-link", True )
            , ( "nav-link--selected", song == currentSong )
            , ( class, True )
            ]
        , Events.onClick (SelectSong song)
        ]
        [ Html.text song.title ]


songLinkMain : Song -> Song -> Html Msg
songLinkMain =
    songLink "song-link-main"


songLinkSmall : Song -> Song -> Html Msg
songLinkSmall =
    songLink "song-link-small"


artistLink : Model -> String -> Html Msg
artistLink model artist =
    Html.div
        [ Attributes.class "artist-link" ]
        [ Html.div
            [ Attributes.classList
                [ ( "nav-link", True )
                , ( "nav-link--selected-artist"
                  , isSelected model.drawerState artist
                  )
                ]
            , Events.onClick (SelectArtist artist)
            ]
            [ Html.text artist ]
        , artistSongView model artist
        ]


artistSongView : Model -> String -> Html Msg
artistSongView model artist =
    if isSelected model.drawerState artist then
        Html.div
            []
            (artistSongs model artist
                |> List.map (songLinkSmall model.currentSong)
            )
    else
        Html.text ""


isSelected : Maybe DrawerMode -> String -> Bool
isSelected drawerState artist =
    case drawerState of
        Just (Artists (Just name)) ->
            artist == name

        _ ->
            False


artistSongs : Model -> String -> List Song
artistSongs model artist =
    sortedSongs model
        |> List.filter ((==) artist << .artist)
        |> List.sortBy .title


navButton : Bool -> Html Msg
navButton openButton =
    let
        msg =
            if openButton then
                OpenDrawer (Artists Nothing)
            else
                CloseDrawer

        title =
            if openButton then
                "Open Menu"
            else
                "Close Menu"
    in
        Html.div
            [ Attributes.classList
                [ ( "nav-button", True )
                , ( "drawer-open", openButton )
                , ( "drawer-close", not openButton )
                ]
            , Attributes.title title
            , Events.onClick msg
            ]
            [ Html.i
                [ Attributes.class "material-icons" ]
                [ Html.text "menu" ]
            ]


playAllButton : Bool -> Html Msg
playAllButton autoplay =
    Html.div
        [ Attributes.classList
            [ ( "play-all-button", True )
            , ( "play-all-button--selected", autoplay )
            ]
        , Attributes.title "Autoplay Mode"
        ]
        [ Html.i
            [ Attributes.class "material-icons"
            , Events.onClick ToggleAutoPlay
            ]
            [ Html.text "playlist_play" ]
        ]


youtubeVideo : String -> Bool -> Html msg
youtubeVideo id autoplay =
    Html.iframe
        [ Attributes.src (youtubeUrl autoplay id)
        , Attributes.height 315
        , Attributes.width 560
        , Attributes.attribute "frameborder" "0"
        , Attributes.attribute "gesture" "media"
        , Attributes.attribute "allow" "encrypted-media"
        , Attributes.attribute "allowfullscreen" ""
        , Attributes.id "video-player"
        ]
        []


youtubeUrl : Bool -> String -> String
youtubeUrl autoplay id =
    "https://www.youtube.com/embed/"
        ++ id
        ++ "?enablejsapi=1"
        ++ (if autoplay then
                "&autoplay=1"
            else
                ""
           )


sortedSongs : Model -> List Song
sortedSongs model =
    (List.reverse model.previousSongs)
        ++ (model.currentSong :: model.nextSongs)


drawerOpen : Maybe DrawerMode -> Bool
drawerOpen drawerState =
    case drawerState of
        Nothing ->
            False

        Just _ ->
            True



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.youtubeStateChange YoutubeStateChange


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
