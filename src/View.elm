module View exposing (view)

import Html exposing (Html, text, div, img, h3, span, button, ul, li)
import Model exposing (Model, Page(..))
import Message exposing (Msg(..))
import Page.ShoppingList.Page as ShoppingListPage exposing (view)
import Page.Edit.Page as EditPage exposing (view)


view : Model -> Html Msg
view model =
    case model.currentPage of
        ShoppingListPage ->
            ShoppingListPage.view model.shoppingList

        EditListPage ->
            EditPage.view model.shoppingList model.itemInput
