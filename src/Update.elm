module Update exposing (update)

import Model exposing (Model)
import Message exposing (Msg(..))
import Material
import ShoppingList.Update as SUpdate exposing (update)
import ItemInput.Update as IUpdate exposing (update)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model

        ToggleShoppingListItem id ->
          ( { model | shoppingList = SUpdate.update model.shoppingList id }, Cmd.none )

        UpdateItemInput value ->
          ( { model | itemInput = IUpdate.update model.itemInput value }, Cmd.none )

        AddItem ->
          ( { model | shoppingList = SUpdate.addItem model.shoppingList model.itemInput.value }, Cmd.none )
