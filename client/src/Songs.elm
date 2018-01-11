module Songs
    exposing
        ( Model
        , Song
        , next
        , previous
        , fromList
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


fromList : List Song -> Maybe Model
fromList list =
    case list of
        [] ->
            Nothing

        x :: xs ->
            Just (SelectList.fromLists [] x xs)
