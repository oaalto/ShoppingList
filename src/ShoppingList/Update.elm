module ShoppingList.Update exposing (update)


import ShoppingList.Model exposing (Model, ShoppingListItem)

update : Model -> Int -> Model
update model id =
  { model | items = updateShoppingList model id }


updateShoppingList : Model -> Int -> List ShoppingListItem
updateShoppingList model id =
  List.map (updateShoppingListItem id) model.items


updateShoppingListItem : Int -> ShoppingListItem -> ShoppingListItem
updateShoppingListItem id item =
  if item.id == id then { item | bought = not item.bought } else item
