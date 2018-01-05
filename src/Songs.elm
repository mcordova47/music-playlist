module Songs
    exposing
        ( Model
        , Song
        , init
        , next
        , previous
        )

import SelectList exposing (SelectList)


type alias Model =
    SelectList Song


type alias Song =
    { video : String
    , title : String
    , artist : String
    , year : Int
    , album : String
    , notes : String
    }


init : SelectList Song
init =
    SelectList.fromLists
        []
        initSelected
        initAfter


next : SelectList a -> Maybe a
next selectList =
    selectList
        |> SelectList.after
        |> List.head


previous : SelectList a -> Maybe a
previous selectList =
    selectList
        |> SelectList.before
        |> List.reverse
        |> List.head


initSelected : Song
initSelected =
    { title = "715 - CR∑∑KS"
    , artist = "Bon Iver"
    , album = "22, A Million"
    , year = 2016
    , video = "P_Fx1yq3A8M"
    , notes = """
Creeks is probably my favorite song from *22, A Million*.  It highlights the
 instrument he uses throughout the album - the Messina - created on his request
 by Justin's sound engineer, Chris Messina.  It basically allows him to create
 harmonies in real-time while he's singing.  Seeing him play this song live is
 incredibly powerful.
"""
    }


initAfter : List Song
initAfter =
    [ { title = "33 \"God\""
      , artist = "Bon Iver"
      , album = "22, A Million"
      , year = 2016
      , video = "6C5sB6AqJkM"
      , notes =
            """
Another haunting song off *22, A Million*.  This was the first of these lyric
 videos released before the album.  I can't begin to untangle all of the
 symbolism in this song/video, but it seems like the narrator is losing his
 faith and feeling betrayed by God.  I love the imagery in this whole album.
  Every song has a number and symbol associated with it.  The symbol
 incorporates the number in some clever way, like the division sign in the album
 cover, a rotated "1" with a comma above and below to represent 1,000,000".
"""
      }
    , { title = "29 #Strafford APTS"
      , artist = "Bon Iver"
      , album = "22, A Million"
      , year = 2016
      , video = "9utVR5Q67_k"
      , notes =
            """
I added Strafford Apts to show the diversity of *22, A Million*.  It sounds like
 some sort of futuristic country song - if country ever went back to its roots
 and stopped being about tractors.
"""
      }
    , { title = "Holocene"
      , artist = "Bon Iver"
      , album = "Bon Iver"
      , year = 2011
      , video = "TWcyIpul8OE"
      , notes =
            """
This is from Bon Iver's self-titled album, a few years before *22, A Million*.
  They expanded their sound way beyond their first album.  The video is
 beautiful, too.
"""
      }
    , { title = "Flume"
      , artist = "Bon Iver"
      , album = "For Emma, Forever Ago"
      , year = 2008
      , video = "LuQrLsTUcN0"
      , notes =
            """
Bon Iver's first album, recorded in a cabin in the woods.  It's much more
 stripped down than the later albums, but they still do some pretty cool things.
 That buzzing sound you hear every once in a while is from an EBow, which
 magnetically vibrates guitar strings, and the buzzing comes from lightly
 touching the EBow to the strings.
"""
      }
    , { title = "Skinny Love"
      , artist = "Bon Iver"
      , album = "For Emma, Forever Ago"
      , year = 2008
      , video = "ssdgFoHLwnk"
      , notes =
            """
*Skinny Love* was the most popular song from Bon Iver's first album.  Even
 before the huge band and experimentation, you can see why they stood out.
  Cryptic lyrics, interesting open tunings, that strange falsetto.  The song
 still holds up.
"""
      }
    , { title = "Happy Birthday, Johnny"
      , artist = "St. Vincent"
      , album = "MASSEDUCTION"
      , year = 2017
      , video = "rGsz05t9Kek"
      , notes =
            """
St. Vincent's songs usually seem like commentaries on society, but for the first
 time, Annie Clark uses her own name in a song.  It's unclear whether Johnny is
 a real person she knew or if any of the stories in the song are true, but this
 song feels deeply personal.  She recalls a time when she "gave [Johnny] Jim
 Carroll" (author of the Basketball Diaries), and how Johnny seemed to model his
 life after it.  It's a beautiful, but upsetting song.
"""
      }
    , { title = "Cruel"
      , artist = "St. Vincent"
      , album = "Strange Mercy"
      , year = 2011
      , video = "Itt0rALeHE8"
      , notes =
            """
This is the first song I heard by St. Vincent.  I just love the way every part
 of the song builds, letting you hear all the layers of the song come together.
"""
      }
    , { title = "Up In Hudson"
      , artist = "Dirty Projectors"
      , album = "Dirty Projectors"
      , year = 2017
      , video = "Ckp0Rlhka_o"
      , notes =
            """
Dave Longstreth's latest album was about his breakup with his former girlfriend
 and bandmate Amber Coffman.  *Up In Hudson* best captures the full story of
 their relationship from beginning to end.  Even in these personal songs, it
 feels like he is always trying to do new things musically.
"""
      }
    , { title = "Swing Lo Magellan"
      , artist = "Dirty Projectors"
      , album = "Swing Lo Magellan"
      , year = 2012
      , video = "yf7OKBlvAig"
      , notes =
            """
Dirty Projectors' songs are usually very eccentric and ornate.  This song is
 so minimal by comparison.  Longstreth's voice has a lot of character.
"""
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
