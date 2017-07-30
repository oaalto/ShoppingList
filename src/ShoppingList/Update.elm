module ShoppingList.Update exposing (update, addItem, removeItem, removeAllItems, removeBoughtItems)

import ShoppingList.Model exposing (Model, ShoppingListItem)


update : Model -> String -> Model
update model name =
    { model | items = updateShoppingList model name }


addItem : Model -> String -> Model
addItem model value =
    { model | items = (ShoppingListItem value False) :: model.items }


removeItem : Model -> String -> Model
removeItem model name =
    { model | items = List.filter (\item -> item.name /= name) model.items }


updateShoppingList : Model -> String -> List ShoppingListItem
updateShoppingList model name =
    List.map (updateShoppingListItem name) model.items


updateShoppingListItem : String -> ShoppingListItem -> ShoppingListItem
updateShoppingListItem name item =
    if item.name == name then
        { item | bought = not item.bought }
    else
        item


removeAllItems : Model -> Model
removeAllItems model =
    { model | items = [] }


removeBoughtItems : Model -> Model
removeBoughtItems model =
    { model | items = filterBoughtItems model.items }


filterBoughtItems : List ShoppingListItem -> List ShoppingListItem
filterBoughtItems =
    List.filter (\item -> not item.bought)
