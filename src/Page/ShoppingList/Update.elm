module Page.ShoppingList.Update exposing (toggleItem, removeAllItems, removeBoughtItems)

import Model.ShoppingList exposing (ShoppingListModel, ShoppingListItem)


toggleItem : ShoppingListModel -> String -> ShoppingListModel
toggleItem model name =
    { model | items = toggleItemInShoppingList model name }


toggleItemInShoppingList : ShoppingListModel -> String -> List ShoppingListItem
toggleItemInShoppingList model name =
    List.map (toggleShoppingListItem name) model.items


toggleShoppingListItem : String -> ShoppingListItem -> ShoppingListItem
toggleShoppingListItem name item =
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
