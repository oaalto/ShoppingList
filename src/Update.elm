module Update exposing (update)

import Model exposing (Model)
import Message exposing (Msg(..))
import Material
import ShoppingList.Update as SUpdate exposing (update)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model

        ToggleShoppingListItem id ->
          ( { model | shoppingList = SUpdate.update model.shoppingList id }, Cmd.none )
