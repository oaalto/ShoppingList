module ShoppingList.Update exposing (update, addItem, removeItem, removeAllItems, removeBoughtItems)

import Model.ShoppingList exposing (ShoppingListModel, ShoppingListItem)


update : ShoppingListModel -> String -> ShoppingListModel
update model name =
    { model | items = updateShoppingList model name }


addItem : ShoppingListModel -> String -> ShoppingListModel
addItem model value =
    { model | items = (ShoppingListItem value False) :: model.items }


removeItem : ShoppingListModel -> String -> ShoppingListModel
removeItem model name =
    { model | items = List.filter (\item -> item.name /= name) model.items }


updateShoppingList : ShoppingListModel -> String -> List ShoppingListItem
updateShoppingList model name =
    List.map (updateShoppingListItem name) model.items


updateShoppingListItem : String -> ShoppingListItem -> ShoppingListItem
updateShoppingListItem name item =
    if item.name == name then
        { item | marked = not item.marked }
    else
        item


removeAllItems : ShoppingListModel -> ShoppingListModel
removeAllItems model =
    { model | items = [] }


removeBoughtItems : ShoppingListModel -> ShoppingListModel
removeBoughtItems model =
    { model | items = filterBoughtItems model.items }


filterBoughtItems : List ShoppingListItem -> List ShoppingListItem
filterBoughtItems =
    List.filter (\item -> not item.marked)
