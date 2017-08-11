module Page.ShoppingList.Page exposing (update, view, init, addItem, removeItem)

import Html exposing (Html)
import Page.ShoppingList.Update as Update exposing (toggleItem)
import Page.ShoppingList.View as View exposing (view)
import Model.ShoppingList exposing (ShoppingListModel, ShoppingListItem)
import Page.ShoppingList.Message as PageMsg exposing (ShoppingListMessage(..), ShoppingListExternalMessage(..))
import Message as GlobalMessage exposing (Msg)


init : ShoppingListModel
init =
    ShoppingListModel []


update : ShoppingListMessage -> ShoppingListModel -> ( ShoppingListModel, ShoppingListExternalMessage )
update msg model =
    case msg of
        ToggleShoppingListItem name ->
            ( Update.toggleItem model name, NoOp )

        RemoveBoughtItems ->
            let
                shoppingList =
                    Update.removeBoughtItems model
            in
                ( shoppingList, SaveToStorage )

        RemoveAllItems ->
            let
                shoppingList =
                    Update.removeAllItems model
            in
                ( shoppingList, SaveToStorage )


view : ShoppingListModel -> Html GlobalMessage.Msg
view shoppingListModel =
    View.view shoppingListModel


addItem : ShoppingListModel -> String -> ShoppingListModel
addItem model value =
    { model | items = (ShoppingListItem value False) :: model.items }


removeItem : ShoppingListModel -> String -> ShoppingListModel
removeItem model name =
    { model | items = List.filter (\item -> item.name /= name) model.items }
