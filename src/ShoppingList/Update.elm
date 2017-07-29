module ShoppingList.Update exposing (update, addItem, removeItem, removeAllItems, removeBoughtItems)

import ShoppingList.Model exposing (Model, ShoppingListItem)


update : Model -> Int -> Model
update model id =
    { model | items = updateShoppingList model id }


addItem : Model -> String -> Int -> Model
addItem model value id =
    { model | items = (ShoppingListItem value False id) :: model.items }


removeItem : Model -> Int -> Model
removeItem model id =
    { model | items = List.filter (\item -> item.id /= id) model.items }


updateShoppingList : Model -> Int -> List ShoppingListItem
updateShoppingList model id =
    List.map (updateShoppingListItem id) model.items


updateShoppingListItem : Int -> ShoppingListItem -> ShoppingListItem
updateShoppingListItem id item =
    if item.id == id then
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
