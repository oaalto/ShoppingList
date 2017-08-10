module View exposing (view)

import Html exposing (Html, text, div, img, h3, span, button, ul, li)
import Model exposing (Model, Page(..))
import Message exposing (Msg(..))
import ShoppingList.View as SList exposing (view, renderHeader)
import ItemInput.View as IView exposing (renderHeader)


view : Model -> Html Msg
view model =
    case model.currentPage of
        ShoppingListPage ->
            viewShoppingListPage model

        EditListPage ->
            viewEditListPage model


viewEditListPage : Model -> Html Msg
viewEditListPage model =
    div []
        [ IView.renderHeader model
        , IView.renderBody model
        ]


viewShoppingListPage : Model -> Html Msg
viewShoppingListPage model =
    div []
        [ SList.renderHeader model
        , SList.view model
        ]
