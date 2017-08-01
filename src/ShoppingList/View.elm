module ShoppingList.View exposing (view, renderHeader)

import Html exposing (..)
import Html.Attributes exposing (class)
import Message exposing (Msg(..))
import ShoppingList.Model exposing (Model, ShoppingListItem)
import Material.List as Lists
import Material.Options as Options
import Material.Button as Button
import Utils exposing (compareNamesIgnoreCase)
import Material
import Material.Grid exposing (grid, cell, size, align, offset, Device(..), Align(..))
import Material.Icon as Icon
import Material.Menu as Menu
import MdlIds exposing (Id(..), toInt)


renderHeader : Model -> Material.Model -> Html Msg
renderHeader model mdl =
    grid [ Options.css "margin" "0" ]
        [ cell [ size All 2 ]
            [ h4 []
                [ text "Shopping List" ]
            ]
        , cell [ size All 1, align Middle ] [ renderEditButton mdl ]
        , cell [ size All 1, align Middle, offset Desktop 8 ] [ renderSettingsButton mdl ]
        ]


renderEditButton : Material.Model -> Html Msg
renderEditButton mdl =
    span [ class "edit-button" ]
        [ Button.render Mdl
            [ toInt EditButton ]
            mdl
            [ Button.fab
            , Button.colored
            , Button.ripple
            , Options.onClick EditMode
            ]
            [ Icon.i "add" ]
        ]


renderSettingsButton : Material.Model -> Html Msg
renderSettingsButton mdl =
    span [ class "settings-button" ]
        [ Menu.render Mdl
            [ toInt SettingsButton ]
            mdl
            [ Menu.bottomRight ]
            [ Menu.item
                [ Menu.onSelect RemoveBoughtItems ]
                [ text "Remove Marked" ]
            , Menu.item
                [ Menu.onSelect RemoveAllItems ]
                [ text "Remove All" ]
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ Lists.ul [] (listItems model.items)
        ]


listItems : List ShoppingListItem -> List (Html Msg)
listItems items =
    items
        |> List.sortWith compareNamesIgnoreCase
        |> List.map listItem


listItem : ShoppingListItem -> Html Msg
listItem item =
    let
        textDecoration =
            if item.bought then
                "line-through"
            else
                "initial"
    in
        Lists.li [ Options.onClick (ToggleShoppingListItem item.name), Options.css "text-decoration" textDecoration ]
            [ Lists.content []
                [ text item.name ]
            ]
