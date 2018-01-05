module Main exposing (main)

import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import List.Extra as List
import Ports
import Navigation exposing (Location)
import Markdown
import Songs exposing (Song)
import SelectList exposing (SelectList)
import Routes exposing (Route(..))


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { songs : Songs.Model
    , drawerState : Maybe DrawerMode
    , autoplay : Bool
    }


type DrawerMode
    = Playlist
    | Artists (Maybe String)


init : Location -> ( Model, Cmd Msg )
init location =
    ( { songs = Songs.init
      , drawerState = Nothing
      , autoplay = False
      }
    , Routes.enterLocation location
    )



-- UPDATE


type Msg
    = CloseDrawer
    | OpenDrawer DrawerMode
    | SelectArtist String
    | YoutubeStateChange Int
    | ToggleAutoPlay
    | UrlChange Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CloseDrawer ->
            ( { model | drawerState = Nothing }, Cmd.none )

        OpenDrawer mode ->
            ( { model | drawerState = Just mode }, Cmd.none )

        SelectArtist artist ->
            ( { model | drawerState = Just (Artists (Just artist)) }, Cmd.none )

        YoutubeStateChange state ->
            if state == 0 && model.autoplay then
                ( model
                , model.songs
                    |> Songs.next
                    |> Maybe.map setUrl
                    |> Maybe.withDefault Cmd.none
                )
            else
                ( model, Cmd.none )

        ToggleAutoPlay ->
            ( { model | autoplay = not model.autoplay }, Cmd.none )

        UrlChange location ->
            ( location
                |> Routes.parseLocation
                |> parseVideo
                |> Maybe.withDefault ""
                |> selectSongById model
            , Cmd.none
            )


setUrl : Song -> Cmd Msg
setUrl song =
    Navigation.newUrl (Routes.url (SongView song.video))


parseVideo : Maybe Route -> Maybe String
parseVideo route =
    case route of
        Just (SongView video) ->
            Just video

        _ ->
            Nothing


selectSongById : Model -> String -> Model
selectSongById model video =
    { model | songs = SelectList.select ((==) video << .video) model.songs }



-- VIEW


view : Model -> Html Msg
view model =
    Html.div
        [ Attributes.class "app-container" ]
        [ songView model
        , navButton True
        , playAllButton model.autoplay
        , navigationView model
        ]


songView : Model -> Html Msg
songView model =
    let
        song =
            SelectList.selected model.songs
    in
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
                [ Html.a
                    [ Attributes.class "arrow"
                    , Attributes.href (previousUrl model)
                    ]
                    [ Html.text "<" ]
                , Html.div
                    [ Attributes.class "song-view__video" ]
                    [ youtubeVideo song.video model.autoplay
                    ]
                , Html.a
                    [ Attributes.class "arrow"
                    , Attributes.href (nextUrl model)
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
    model.songs
        |> SelectList.toList
        |> List.map .artist
        |> List.distinct
        |> List.sort
        |> List.map (artistLink model)


songList : Model -> List (Html Msg)
songList model =
    model.songs
        |> SelectList.toList
        |> List.map (songLinkMain (SelectList.selected model.songs))


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
    Html.a
        [ Attributes.classList
            [ ( "nav-link", True )
            , ( "nav-link--selected", song == currentSong )
            , ( class, True )
            ]
        , Attributes.href (Routes.url (SongView song.video))
        ]
        [ Html.text song.title ]


songLinkMain : Song -> Song -> Html Msg
songLinkMain =
    songLink "song-link-main"


songLinkSmall : Song -> Song -> Html Msg
songLinkSmall =
    songLink "song-link-small"


nextUrl : Model -> String
nextUrl model =
    model.songs
        |> Songs.next
        |> Maybe.map .video
        |> Maybe.map (Routes.url << SongView)
        |> Maybe.withDefault "#"


previousUrl : Model -> String
previousUrl model =
    model.songs
        |> Songs.previous
        |> Maybe.map .video
        |> Maybe.map (Routes.url << SongView)
        |> Maybe.withDefault "#"


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
                |> List.map (songLinkSmall (SelectList.selected model.songs))
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
    model.songs
        |> SelectList.toList
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
