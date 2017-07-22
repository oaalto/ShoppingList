module MdlIds exposing (Id(..), toInt)


type Id
    = EditButton
    | AddButton
    | DoneButton
    | ItemField


toInt : Id -> Int
toInt id =
    case id of
        EditButton ->
            0

        AddButton ->
            1

        DoneButton ->
            2

        ItemField ->
            3
