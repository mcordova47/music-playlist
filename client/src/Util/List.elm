module Util.List exposing (distinct)


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
