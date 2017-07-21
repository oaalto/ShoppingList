module Utils exposing (compareNamesIgnoreCase)


compareNamesIgnoreCase : { a | name : String } -> { b | name : String } -> Order
compareNamesIgnoreCase a b =
    case compare (String.toUpper a.name) (String.toUpper b.name) of
        LT ->
            LT

        EQ ->
            EQ

        GT ->
            GT
