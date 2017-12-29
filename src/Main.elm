module Main exposing (..)

import Html exposing (Html)
import Html.Attributes as Attributes
import Html.Events as Events
import List.Extra as List
import Ports
import Navigation exposing (Location)
import UrlParser exposing ((</>))


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


type alias Song =
    { video : String
    , title : String
    , artist : String
    , year : Int
    , album : String
    , notes : String
    }


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
      , currentSong =
            { title = "715 - CR∑∑KS"
            , artist = "Bon Iver"
            , album = "22, A Million"
            , year = 2016
            , video = "P_Fx1yq3A8M"
            , notes =
                String.join ""
                    [ "Creeks is probably my favorite song from 22, A Million."
                    , "  It highlights the instrument he uses throughout the "
                    , "album - the Messina - created on his request by Justin's"
                    , " sound engineer, Chris Messina.  It basically allows him"
                    , " to create harmonies in real-time while he's singing.  "
                    , "Seeing him play this song live is incredibly powerful."
                    ]
            }
      , nextSongs =
            [ { title = "33 \"God\""
              , artist = "Bon Iver"
              , album = "22, A Million"
              , year = 2016
              , video = "6C5sB6AqJkM"
              , notes =
                    String.join ""
                        [ "Another haunting song off 22, A Million.  This was the "
                        , "first of these lyric videos released before the album."
                        , "  I can't begin to untangle all of the symbolism in "
                        , "this song/video, but it seems like the narrator is "
                        , "losing his faith and feeling betrayed by God.  I love "
                        , "the imagery in this whole album.  Every song has a "
                        , "number and symbol associated with it.  The symbol "
                        , "incorporates the number in some clever way, like the "
                        , "division sign in the album cover, a rotated \"1\" "
                        , "with a comma above and below to represent "
                        , "\"1,000,000\"."
                        ]
              }
            , { title = "29 #Strafford APTS"
              , artist = "Bon Iver"
              , album = "22, A Million"
              , year = 2016
              , video = "9utVR5Q67_k"
              , notes =
                    String.join ""
                        [ "I added Strafford Apts to show the diversity of 22, "
                        , "A Million.  It sounds like some sort of futuristic "
                        , "country song - if country ever went back to its "
                        , "roots and stopped being about tractors."
                        ]
              }
            , { title = "Holocene"
              , artist = "Bon Iver"
              , album = "Bon Iver"
              , year = 2011
              , video = "TWcyIpul8OE"
              , notes =
                    String.join ""
                        [ "This is from Bon Iver's self-titled album, a few years "
                        , "before 22, A Million.  They expanded their sound way "
                        , "beyond their first album.  The video is beautiful, too."
                        ]
              }
            , { title = "Flume"
              , artist = "Bon Iver"
              , album = "For Emma, Forever Ago"
              , year = 2008
              , video = "LuQrLsTUcN0"
              , notes =
                    String.join ""
                        [ "Bon Iver's first album, recorded in a cabin in the "
                        , "woods.  It's much more stripped down than the later "
                        , "albums, but they still do some pretty cool things.  "
                        , "That buzzing sound you hear every once in a while "
                        , "is from an EBow, which magnetically vibrates guitar "
                        , "strings, and the buzzing comes from lightly touching"
                        , " the EBow to the strings."
                        ]
              }
            , { title = "Skinny Love"
              , artist = "Bon Iver"
              , album = "For Emma, Forever Ago"
              , year = 2008
              , video = "ssdgFoHLwnk"
              , notes =
                    String.join ""
                        [ "Skinny Love was the most popular song from Bon "
                        , "Iver's first album.  Even before the huge band and "
                        , "experimentation, you can see why they stood out.  "
                        , "Cryptic lyrics, interesting open tunings, that "
                        , "strange falsetto.  The song still holds up."
                        ]
              }
            , { title = "Happy Birthday, Johnny"
              , artist = "St. Vincent"
              , album = "MASSEDUCTION"
              , year = 2017
              , video = "rGsz05t9Kek"
              , notes =
                    String.join ""
                        [ "St. Vincent's songs usually seem like commentaries on "
                        , "society, but for the first time, Annie Clark uses her "
                        , "own name in a song.  It's unclear whether Johnny is a "
                        , "real person she knew or if any of the stories in the "
                        , "song are true, but this song feels deeply personal.  "
                        , "She recalls a time when she \"gave [Johnny] Jim Carroll\" "
                        , "(author of the Basketball Diaries), and how Johnny "
                        , "seemed to model his life after it.  It's a beautiful, "
                        , "but upsetting song."
                        ]
              }
            , { title = "Cruel"
              , artist = "St. Vincent"
              , album = "Strange Mercy"
              , year = 2011
              , video = "Itt0rALeHE8"
              , notes =
                    String.join ""
                        [ "This is the first song I heard by St. Vincent.  I just "
                        , "love the way every part of the song builds, letting "
                        , "you hear all the layers of the song come together."
                        ]
              }
            , { title = "Up In Hudson"
              , artist = "Dirty Projectors"
              , album = "Dirty Projectors"
              , year = 2017
              , video = "Ckp0Rlhka_o"
              , notes =
                    String.join ""
                        [ "Dave Longstreth's latest album was about his breakup "
                        , "with his former girlfriend and bandmate Amber Coffman."
                        , "  Up In Hudson best captures the full story of their "
                        , "relationship from beginning to end.  Even in these "
                        , "personal songs, it feels like he is always trying "
                        , "to do new things musically."
                        ]
              }
            , { title = "Swing Lo Magellan"
              , artist = "Dirty Projectors"
              , album = "Swing Lo Magellan"
              , year = 2012
              , video = "yf7OKBlvAig"
              , notes =
                    String.join ""
                        [ "Dirty Projectors' songs are usually very eccentric "
                        , "and ornate.  This song is so minimal by comparison."
                        , "  Longstreth's voice has a lot of character."
                        ]
              }
            , { title = "Unto Caesar"
              , artist = "Dirty Projectors"
              , album = "Swing Lo Magellan"
              , year = 2012
              , video = "Wt-eVWuz9Mw"
              , notes = ""
              }
            , { title = "Cannibal Resource"
              , artist = "Dirty Projectors"
              , album = "Bitte Orca"
              , year = 2009
              , video = "ZbpONp5j8fc"
              , notes = ""
              }
            , { title = "Temecula Sunrise"
              , artist = "Dirty Projectors"
              , album = "Bitte Orca"
              , year = 2009
              , video = "OiabqXilmwA"
              , notes = ""
              }
            , { title = "Step"
              , artist = "Vampire Weekend"
              , album = "Modern Vampires of the City"
              , year = 2013
              , video = "_mDxcDjg9P4"
              , notes = ""
              }
            , { title = "Ya Hey"
              , artist = "Vampire Weekend"
              , album = "Modern Vampires of the City"
              , year = 2013
              , video = "i-BznQE6B8U"
              , notes = ""
              }
            , { title = "Hanna Hunt"
              , artist = "Vampire Weekend"
              , album = "Modern Vampires of the City"
              , year = 2013
              , video = "uDwVMcEHG70"
              , notes = ""
              }
            , { title = "Taxi Cab"
              , artist = "Vampire Weekend"
              , album = "Contra"
              , year = 2010
              , video = "4BjLljMzcUU"
              , notes = ""
              }
            , { title = "I Think Ur A Contra"
              , artist = "Vampire Weekend"
              , album = "Contra"
              , year = 2010
              , video = "XwJQlUQjeS4"
              , notes = ""
              }
            , { title = "This Will Be Our Year"
              , artist = "The Zombies"
              , album = "Odessey and Oracle"
              , year = 1968
              , video = "kI2lTwY0Jx8"
              , notes = ""
              }
            , { title = "Sunshine Superman"
              , artist = "Donovan"
              , album = "Sunshine Superman"
              , year = 1966
              , video = "YsX2FhBf9nY"
              , notes = ""
              }
            , { title = "Ferris Wheel"
              , artist = "Donovan"
              , album = "Sunshine Superman"
              , year = 1966
              , video = "-fuD6Or2nPU"
              , notes = ""
              }
            , { title = "Diamond Day"
              , artist = "Vashti Bunyan"
              , album = "Just Another Diamond Day"
              , year = 1970
              , video = "7-HDcMplduA"
              , notes = ""
              }
            , { title = "Deep Blue Sea"
              , artist = "Grizzly Bear"
              , album = "Dark Was The Night (Red Hot Compilation)"
              , year = 2009
              , video = "UdiF2n9Vs8E"
              , notes = ""
              }
            , { title = "Young Trouble"
              , artist = "Sinkane"
              , album = "Mean Love"
              , year = 2014
              , video = "rHOxwYS97Pw"
              , notes = ""
              }
            , { title = "Unconditional Love"
              , artist = "Esperanza Spalding"
              , album = "Emily's D+Evolution"
              , year = 2016
              , video = "XiF9fSeu4Q0"
              , notes = ""
              }
            , { title = "Judas"
              , artist = "Esperanza Spalding"
              , album = "Emily's D+Evolution"
              , year = 2016
              , video = "hZo1ZIZW21Y"
              , notes = ""
              }
            , { title = "Bizness"
              , artist = "tUnE-yArDs"
              , album = "W H O K I L L"
              , year = 2011
              , video = "YQ1LI-NTa2s"
              , notes = ""
              }
            , { title = "Powa"
              , artist = "tUnE-yArDs"
              , album = "W H O K I L L"
              , year = 2011
              , video = "y__zyyzg0v0"
              , notes = ""
              }
            , { title = "Sinnerman"
              , artist = "Nina Simone"
              , album = "Pastel Blues"
              , year = 1965
              , video = "odYf2rHoJsQ"
              , notes = ""
              }
            , { title = "My Auntie's Building"
              , artist = "Open Mike Eagle"
              , album = "Brick Body Kids Still Daydream"
              , year = 2017
              , video = "wGCPWkcFvN4"
              , notes =
                    String.join ""
                        [ "This is a song I happened upon looking at Pitchfork's"
                        , "\"Best of 2017\" list.  The album is all about a "
                        , "project in Chicago Mike Eagle grew up in called the "
                        , "Robert Taylor homes, and how they tore it down and "
                        , "displaced the people who lived there.  This is "
                        , "the last song on the album filled with sounds of "
                        , "his aunt's building being torn down."
                        ]
              }
            , { title = "Eventually"
              , artist = "Tame Impala"
              , album = "Currents"
              , year = 2015
              , video = "zfwqXQo0iCk"
              , notes = ""
              }
            , { title = "Feels Like We Only Go Backwards"
              , artist = "Tame Impala"
              , album = "Lonerism"
              , year = 2012
              , video = "wycjnCCgUes"
              , notes = ""
              }
            , { title = "New Slang"
              , artist = "The Shins"
              , album = "Oh, Inverted World"
              , year = 2001
              , video = "zYwCmcB0XMw"
              , notes = ""
              }
            , { title = "King Of Carrot Flowers, Pt 1"
              , artist = "Neutral Milk Hotel"
              , album = "In the Aeroplane Over the Sea"
              , year = 1998
              , video = "LULmbLlPvVk"
              , notes = ""
              }
            , { title = "In the Aeroplane Over the Sea"
              , artist = "Neutral Milk Hotel"
              , album = "In the Aeroplane Over the Sea"
              , year = 1998
              , video = "hD6_QXwKesU"
              , notes = ""
              }
            , { title = "Cello Song"
              , artist = "Nick Drake"
              , album = "Five Leaves Left"
              , year = 1969
              , video = "R4XUiEWZLas"
              , notes = ""
              }
            , { title = "One Of These Things First"
              , artist = "Nick Drake"
              , album = "Bryter Layter"
              , year = 1970
              , video = "UPiIth9mX2U"
              , notes = ""
              }
            , { title = "Which Will"
              , artist = "Nick Drake"
              , album = "Pink Moon"
              , year = 1972
              , video = "A0NDxRNdQKk"
              , notes = ""
              }
            , { title = "Tomorrow Tomorrow"
              , artist = "Elliott Smith"
              , album = "XO"
              , year = 1998
              , video = "1Exj9DOwNXQ"
              , notes = ""
              }
            , { title = "Needle In The Hay"
              , artist = "Elliott Smith"
              , album = "Elliott Smith"
              , year = 1995
              , video = "EgNgvCLRqWc"
              , notes = ""
              }
            , { title = "Satellite"
              , artist = "Elliott Smith"
              , album = "Elliott Smith"
              , year = 1995
              , video = "2CeziKHlsIY"
              , notes = ""
              }
            , { title = "Say Yes"
              , artist = "Elliott Smith"
              , album = "Either/Or"
              , year = 1997
              , video = "8bxmk09lCzk"
              , notes = ""
              }
            , { title = "The Boy With The Arab Strap"
              , artist = "Belle & Sebastian"
              , album = "The Boy With The Arab Strap"
              , year = 1998
              , video = "8HdAplWpqWA"
              , notes = ""
              }
            , { title = "Love Love Love"
              , artist = "The Mountain Goats"
              , album = "The Sunset Tree"
              , year = 2005
              , video = "GOPCAQi3UMg"
              , notes = ""
              }
            , { title = "Wild Sage"
              , artist = "The Mountain Goats"
              , album = "Get Lonely"
              , year = 2006
              , video = "O_V6D1Dd8Kc"
              , notes = ""
              }
            , { title = "The Book Of Love"
              , artist = "The Magnetic Fields"
              , album = "69 Love Songs"
              , year = 1999
              , video = "jkjXr9SrzQE"
              , notes = ""
              }
            , { title = "Little Blu House"
              , artist = "Unknown Mortal Orchestra"
              , album = "Unknown Mortal Orchestra"
              , year = 2011
              , video = "O1MXLOpnhCU"
              , notes = ""
              }
            , { title = "Demon"
              , artist = "Shamir"
              , album = "Ratchet"
              , year = 2015
              , video = "L5OzO4uF_1A"
              , notes = ""
              }
            , { title = "The Oh So Protective One"
              , artist = "Girls"
              , album = "Broken Dreams Club"
              , year = 2010
              , video = "BgNQUYWzItg"
              , notes = ""
              }
            , { title = "Sympathy"
              , artist = "Sleater-Kinney"
              , album = "One Beat"
              , year = 2002
              , video = "2mOrhpSWTec"
              , notes =
                    String.join ""
                        [ "I'm not sure you'd like many of their songs, but Sleater-"
                        , "Kinney is a pretty talented band.  The guitarist is also "
                        , "in the show Portlandia and is very funny.  I thought you'd"
                        , " appreciate this song, since it was written by the lead "
                        , "singer about her son when she was pregnant and the doctor "
                        , "wasn't sure whether he would survive.  The emotion really "
                        , "comes through in her voice."
                        ]
              }
            , { title = "Lua"
              , artist = "Bright Eyes"
              , album = "I'm Wide Awake, It's Morning"
              , year = 2005
              , video = "TSBs-hiapo4"
              , notes = ""
              }
            , { title = "White Winter Hymnal"
              , artist = "Fleet Foxes"
              , album = "Fleet Foxes"
              , year = 2008
              , video = "DrQRS40OKNE"
              , notes = ""
              }
            , { title = "Blue Ridge Mountains"
              , artist = "Fleet Foxes"
              , album = "Fleet Foxes"
              , year = 2008
              , video = "L5dUsZ4Djd0"
              , notes = ""
              }
            , { title = "Bedouin Dress"
              , artist = "Fleet Foxes"
              , album = "Helplessness Blues"
              , year = 2011
              , video = "K6R9Ia0VdTg"
              , notes = ""
              }
            , { title = "Helplessness Blues"
              , artist = "Fleet Foxes"
              , album = "Helplessness Blues"
              , year = 2011
              , video = "7HHgedNNQco"
              , notes = ""
              }
            , { title = "Blue Spotted Tail"
              , artist = "Fleet Foxes"
              , album = "Helplessness Blues"
              , year = 2011
              , video = "teElNB0WuDI"
              , notes = ""
              }
            , { title = "Upward Over the Mountain"
              , artist = "Iron & Wine"
              , album = "The Creek Drank The Cradle"
              , year = 2002
              , video = "Cg4CCy2kbuA"
              , notes = ""
              }
            , { title = "Pagan Angel and a Borrowed Car"
              , artist = "Iron & Wine"
              , album = "The Shepherd's Dog"
              , year = 2007
              , video = "ggvvAliAr64"
              , notes = ""
              }
            , { title = "Lovesong of the Buzzard"
              , artist = "Iron & Wine"
              , album = "The Shepherd's Dog"
              , year = 2007
              , video = "j9xZY57tzDs"
              , notes = ""
              }
            , { title = "Innocent Bones"
              , artist = "Iron & Wine"
              , album = "The Shepherd's Dog"
              , year = 2007
              , video = "DQ7Gcj1Ff8g"
              , notes = ""
              }
            , { title = "The Trapeze Swinger"
              , artist = "Iron & Wine"
              , album = "Around The Well"
              , year = 2009
              , video = "yt7O8gDy0DA"
              , notes = ""
              }
            , { title = "No Shade in the Shadow of the Cross"
              , artist = "Sufjan Stevens"
              , album = "Carrie & Lowell"
              , year = 2015
              , video = "qx1s_3CF07k"
              , notes = ""
              }
            , { title = "Casimir Pulaski Day"
              , artist = "Sufjan Stevens"
              , album = "Illinoise"
              , year = 2005
              , video = "TfEkDqP34xo"
              , notes = ""
              }
            , { title = "The Predatory Wasp of The Palisades Is Out To Get Us"
              , artist = "Sufjan Stevens"
              , album = "Illinoise"
              , year = 2005
              , video = "KBse9Y6zucs"
              , notes = ""
              }
            , { title = "Pulaski"
              , artist = "Andrew Bird"
              , album = "Are You Serious"
              , year = 2016
              , video = "wIKOSykz0xQ"
              , notes = ""
              }
            , { title = "Mushaboom"
              , artist = "Feist"
              , album = "Let It Die"
              , year = 2004
              , video = "0TMIe7P9gcI"
              , notes = ""
              }
            , { title = "Hold On"
              , artist = "Tom Waits"
              , album = "Mule Variations"
              , year = 1999
              , video = "WPnOEiehONQ"
              , notes = ""
              }
            , { title = "Take It With Me"
              , artist = "Tom Waits"
              , album = "Mule Variations"
              , year = 1999
              , video = "Dixxse4dpQ4"
              , notes = ""
              }
            , { title = "Isolation"
              , artist = "John Lennon"
              , album = "Plastic Ono Band"
              , year = 1970
              , video = "N8lOLNfnCBg"
              , notes = ""
              }
            ]
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
                [ Html.text song.notes ]
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
