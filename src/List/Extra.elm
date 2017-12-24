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
