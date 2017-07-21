module ShoppingList.View exposing (view)

import Html exposing (..)
import Message exposing (Msg(..))
import ShoppingList.Model exposing (Model, ShoppingListItem)
import Material.List as Lists
import Material.Options as Options

view : Model -> Html Msg
view model =
    div []
        [ Lists.ul [] (listItems model.items)
        ]


listItems : List ShoppingListItem -> List (Html Msg)
listItems items =
    List.map listItem items


listItem : ShoppingListItem -> Html Msg
listItem item =
    let
      textDecoration = if item.bought then "line-through" else "initial"
    in
      Lists.li [ Options.onClick (ToggleShoppingListItem item.id), Options.css "text-decoration" textDecoration ]
        [ Lists.content []
          [ text item.name ]
        ]

