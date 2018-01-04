module List.Extra exposing (..)


takeWhile : (a -> Bool) -> List a -> List a
takeWhile predicate list =
    case list of
        [] ->
            []

        x :: xs ->
            if predicate x then
                x :: (takeWhile predicate xs)
            else
                []


dropWhile : (a -> Bool) -> List a -> List a
dropWhile predicate list =
    case list of
        [] ->
            []

        x :: xs ->
            if predicate x then
                dropWhile predicate xs
            else
                list


span : (a -> Bool) -> List a -> ( List a, List a )
span p list =
    ( takeWhile p list, dropWhile p list )


distinct : List a -> List a
distinct =
    List.foldl
        (\item acc ->
            if not (elem item acc) then
                item :: acc
            else
                acc
        )
        []


elem : a -> List a -> Bool
elem a =
    List.any ((==) a)


safeTail : List a -> List a
safeTail list =
    case list of
        [] ->
            []

        x :: xs ->
            xs
