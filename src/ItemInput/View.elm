module ItemInput.View exposing (renderHeader, renderBody)

import ItemInput.Model exposing (Model)
import Html exposing (Html, div, text, span, form, h4, p)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onSubmit)
import Message exposing (Msg(..))
import Material
import Material.Textfield as Textfield
import Material.Options as Options
import Material.Button as Button
import Material.List as Lists
import Utils exposing (compareNamesIgnoreCase)
import History.HistoryItem exposing (HistoryItem)
import MdlIds exposing (Id(..), toInt)
import ShoppingList.Model exposing (ShoppingListItem)
import Material.Grid exposing (grid, cell, size, align, Device(..), Align(..))


renderHeader : Model -> Material.Model -> Html Msg
renderHeader model mdl =
    grid [ Options.css "margin" "0" ]
        [ cell [ size All 11, size Phone 3 ] [ viewTextfield model mdl ]
        , cell [ size All 1, align Middle ] [ renderDoneButton mdl ]
        ]


viewTextfield : Model -> Material.Model -> Html Msg
viewTextfield model mdl =
    form [ onSubmit AddItem ]
        [ Textfield.render Mdl
            [ toInt ItemField ]
            mdl
            [ Textfield.value model.value
            , Textfield.label "Add items"
            , Options.css "width" "100%"
            , Options.onInput UpdateItemInput
            ]
            []
        ]


renderBody : Model -> Material.Model -> List ShoppingListItem -> Html Msg
renderBody model mdl shoppingListItems =
    Lists.ul [] (listItems model shoppingListItems)


listItems : Model -> List ShoppingListItem -> List (Html Msg)
listItems model shoppingListItems =
    model.history
        |> List.filter (filterItems model.value)
        |> List.sortWith compareNamesIgnoreCase
        |> List.map (listItem shoppingListItems)


filterItems : String -> HistoryItem -> Bool
filterItems value item =
    String.contains value item.name


listItem : List ShoppingListItem -> HistoryItem -> Html Msg
listItem shoppingListItems item =
    let
        textColor =
            if isSelected item shoppingListItems then
                "gray"
            else
                "black"
    in
        Lists.li
            [ Options.onClick (historyItemMsg item shoppingListItems)
            , Options.css "color" textColor
            ]
            [ Lists.content []
                [ text item.name ]
            ]


isSelected : HistoryItem -> List ShoppingListItem -> Bool
isSelected historyItem shoppingListItems =
    List.any (\item -> item.name == historyItem.name) shoppingListItems


historyItemMsg : HistoryItem -> List ShoppingListItem -> Msg
historyItemMsg item shoppingListItems =
    if isSelected item shoppingListItems then
        RemoveHistoryItem item.name
    else
        AddHistoryItem item.name


isAddButtonDisabled : String -> List HistoryItem -> Bool
isAddButtonDisabled value items =
    String.isEmpty value || List.any (\item -> item.name == value) items


renderDoneButton : Material.Model -> Html Msg
renderDoneButton mdl =
    span [ class "done-button" ]
        [ Button.render Mdl
            [ toInt DoneButton ]
            mdl
            [ Button.raised
            , Button.colored
            , Button.ripple
            , Options.onClick ListMode
            ]
            [ text "Done" ]
        ]
