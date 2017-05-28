module View exposing (view)

import Html exposing (Html, text, div, img)
import Html.Attributes exposing (src)
import Model exposing (Model, Page(..))
import Message exposing (Msg)
import ShoppingList.View as SList exposing (view)


view : Model -> Html Msg
view model =
    case model.currentPage of
        ShoppingListPage ->
            SList.view model.shoppingList
