module MdlIds exposing (Id(..), toInt)


type Id
    = EditButton
    | DoneButton
    | ItemField
    | SettingsButton


toInt : Id -> Int
toInt id =
    case id of
        EditButton ->
            0

        DoneButton ->
            1

        ItemField ->
            2

        SettingsButton ->
            3
