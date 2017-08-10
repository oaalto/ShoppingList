module View exposing (view)

import Html exposing (Html, text, div, img, h3, span, button, ul, li)
import Model exposing (Model, Page(..))
import Message exposing (Msg(..))
import ShoppingList.View as SList exposing (view, renderHeader)
import Page.Edit.Page as EditPage exposing (view)


view : Model -> Html Msg
view model =
    case model.currentPage of
        ShoppingListPage ->
            viewShoppingListPage model

        EditListPage ->
            EditPage.view model.shoppingList model.itemInput


viewShoppingListPage : Model -> Html Msg
viewShoppingListPage model =
    div []
        [ SList.renderHeader model
        , SList.view model
        ]
