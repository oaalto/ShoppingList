module ShoppingList.View exposing (view)

import Html exposing (..)
import Message exposing (Msg)
import ShoppingList.Model exposing (Model, ShoppingListItem)


view : Model -> Html Msg
view model =
    div []
        [ ul [] (listItems model.items)
        ]


listItems : List ShoppingListItem -> List (Html Msg)
listItems items =
    List.map listItem items


listItem : ShoppingListItem -> Html Msg
listItem item =
    li []
        [ text item.name
        ]
