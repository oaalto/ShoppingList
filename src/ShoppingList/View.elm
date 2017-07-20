module ShoppingList.View exposing (view)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import Message exposing (Msg(..))
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
    let
      textDecoration = if item.bought then "line-through" else "initial"
    in
      li [ onClick (ToggleShoppingListItem item.id), style [("text-decoration", textDecoration)] ]
          [ text item.name
          ]
