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
import Formatting exposing (Format, (<>), s, string)
import Json.Decode as Decode exposing (Value, decodeValue)
import Requests
import RemoteData exposing (RemoteData(..), WebData)
import Http exposing (Error(..))


main : Program Value Model Msg
main =
    Navigation.programWithFlags UrlChange
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { songs : WebData Songs.Model
    , drawerState : Maybe DrawerMode
    , autoplay : Bool
    }


type DrawerMode
    = Playlist
    | Artists (Maybe String)


init : Value -> Location -> ( Model, Cmd Msg )
init value location =
    ( { songs = Loading
      , drawerState = Nothing
      , autoplay = False
      }
    , decodeValue Decode.bool value
        |> Result.withDefault True
        |> Requests.songs
        |> RemoteData.sendRequest
        |> Cmd.map (RetrieveSongs location)
    )



-- UPDATE


type Msg
    = CloseDrawer
    | OpenDrawer DrawerMode
    | SelectArtist String
    | YoutubeStateChange Int
    | ToggleAutoPlay
    | UrlChange Location
    | RetrieveSongs Location (WebData Songs.Model)


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
                    |> RemoteData.map Songs.next
                    |> RemoteData.withDefault Nothing
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

        RetrieveSongs location result ->
            ( { model | songs = result }
            , result
                |> RemoteData.map
                    (Routes.enterLocation location << SelectList.selected)
                |> RemoteData.withDefault Cmd.none
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
    { model
        | songs =
            RemoteData.map
                (SelectList.select ((==) video << .video))
                model.songs
    }



-- VIEW


remoteView : (a -> Html msg) -> RemoteData e a -> Html msg
remoteView view data =
    data
        |> RemoteData.map view
        |> RemoteData.withDefault (Html.text "")


view : Model -> Html Msg
view model =
    Html.div
        [ Attributes.class "app-container" ]
        [ songViewRemote model.autoplay model.songs
        , navButton True
        , playAllButton model.autoplay
        , remoteView (navigationView model.drawerState) model.songs
        ]


songViewRemote : Bool -> WebData Songs.Model -> Html Msg
songViewRemote autoplay data =
    case data of
        Failure err ->
            Html.div
                [ Attributes.class "song-view--error" ]
                [ Html.div [ Attributes.class "buffer" ] []
                , Html.div []
                    [ Html.text (songsError err) ]
                , Html.div [ Attributes.class "buffer" ] []
                ]

        Success songs ->
            songView autoplay songs

        _ ->
            Html.text ""


songView : Bool -> Songs.Model -> Html Msg
songView autoplay songs =
    let
        song =
            SelectList.selected songs
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
                    , Attributes.href (previousUrl songs)
                    ]
                    [ Html.text "<" ]
                , Html.div
                    [ Attributes.class "song-view__video" ]
                    [ youtubeVideo song.video autoplay
                    ]
                , Html.a
                    [ Attributes.class "arrow"
                    , Attributes.href (nextUrl songs)
                    ]
                    [ Html.text ">" ]
                ]
            , Html.div
                [ Attributes.class "song-view__notes" ]
                [ Html.p []
                    [ Markdown.toHtml [] song.notes ]
                ]
            ]


songsError : Error -> String
songsError err =
    case err of
        BadUrl _ ->
            "Failed to retrieve songs."

        Timeout ->
            "Failed to retrieve songs.  Network Timed out."

        NetworkError ->
            "Failed to retrieve songs.  No network connection."

        BadStatus resp ->
            "Failed to retrieve songs.  " ++ resp.status.message ++ "."

        BadPayload msg resp ->
            "Failed to retrieve songs.  Received an unexpected response."


navigationView : Maybe DrawerMode -> Songs.Model -> Html Msg
navigationView drawerState songs =
    Html.div
        [ Attributes.classList
            [ ( "navigation-view", True )
            , ( "navigation-view--open", drawerOpen drawerState )
            ]
        ]
        [ navViewHeader drawerState
        , navList drawerState songs
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


artistList : Maybe DrawerMode -> Songs.Model -> List (Html Msg)
artistList drawerState songs =
    songs
        |> SelectList.toList
        |> List.map .artist
        |> List.distinct
        |> List.sort
        |> List.map (artistLink drawerState songs)


songList : Songs.Model -> List (Html Msg)
songList songs =
    songs
        |> SelectList.toList
        |> List.map (songLinkMain (SelectList.selected songs))


listFunc : DrawerMode -> Songs.Model -> List (Html Msg)
listFunc drawerMode =
    case drawerMode of
        Playlist ->
            songList

        Artists _ ->
            artistList (Just drawerMode)


navList : Maybe DrawerMode -> Songs.Model -> Html Msg
navList drawerState songs =
    let
        listFn =
            drawerState
                |> Maybe.map listFunc
                |> Maybe.withDefault (\_ -> [])
    in
        Html.div
            [ Attributes.class "nav-list" ]
            (listFn songs)


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


nextUrl : Songs.Model -> String
nextUrl songs =
    songs
        |> Songs.next
        |> Maybe.map .video
        |> Maybe.map (Routes.url << SongView)
        |> Maybe.withDefault "#"


previousUrl : Songs.Model -> String
previousUrl songs =
    songs
        |> Songs.previous
        |> Maybe.map .video
        |> Maybe.map (Routes.url << SongView)
        |> Maybe.withDefault "#"


artistLink : Maybe DrawerMode -> Songs.Model -> String -> Html Msg
artistLink drawerState songs artist =
    Html.div
        [ Attributes.class "artist-link" ]
        [ Html.div
            [ Attributes.classList
                [ ( "nav-link", True )
                , ( "nav-link--selected-artist"
                  , isSelected drawerState artist
                  )
                ]
            , Events.onClick (SelectArtist artist)
            ]
            [ Html.text artist ]
        , artistSongView drawerState songs artist
        ]


artistSongView : Maybe DrawerMode -> Songs.Model -> String -> Html Msg
artistSongView drawerState songs artist =
    if isSelected drawerState artist then
        Html.div
            []
            (artistSongs songs artist
                |> List.map (songLinkSmall (SelectList.selected songs))
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


artistSongs : Songs.Model -> String -> List Song
artistSongs songs artist =
    songs
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
        [ Attributes.src (youtubeUrl id autoplay)
        , Attributes.height 315
        , Attributes.width 560
        , Attributes.attribute "frameborder" "0"
        , Attributes.attribute "gesture" "media"
        , Attributes.attribute "allow" "encrypted-media"
        , Attributes.attribute "allowfullscreen" ""
        , Attributes.id "video-player"
        ]
        []


youtubeUrl : String -> Bool -> String
youtubeUrl =
    (s "https://www.youtube.com/embed/" <> string <> s "?enablejsapi=1&autoplay=" <> bit)
        |> Formatting.print


bit : Format r (Bool -> r)
bit =
    Formatting.toFormatter
        (\bool ->
            if bool then
                "1"
            else
                "0"
        )


drawerOpen : Maybe DrawerMode -> Bool
drawerOpen drawerState =
    case drawerState of
        Nothing ->
            False

        Just _ ->
            True



-- SUBSCRIPTIONS


decodeYTState : Value -> Int
decodeYTState =
    decodeValue Decode.int >> Result.withDefault -1


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.youtubeStateChange (YoutubeStateChange << decodeYTState)
