module ShoppingList.Update exposing (update, addItem, removeItem)

import ShoppingList.Model exposing (Model, ShoppingListItem)


update : Model -> Int -> Model
update model id =
    { model | items = updateShoppingList model id }


addItem : Model -> String -> Model
addItem model value =
    let
        id =
            model.idCount + 1
    in
        { model | items = (ShoppingListItem value False id) :: model.items, idCount = id }


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
