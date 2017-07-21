module Update exposing (update)

import Model exposing (Model, Page(..))
import ItemInput.Model exposing (HistoryItem)
import Message exposing (Msg(..))
import Material
import ShoppingList.Update as SUpdate exposing (update)
import ItemInput.Update as IUpdate exposing (update, clearInput, toggleSelected)


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
            ( { model
                | shoppingList = SUpdate.addItem model.shoppingList model.itemInput.value
                , itemInput = IUpdate.clearInput model.itemInput
              }
            , Cmd.none
            )

        EditMode ->
            ( { model | currentPage = EditListPage }, Cmd.none )

        ListMode ->
            ( { model | currentPage = ShoppingListPage }, Cmd.none )

        AddHistoryItem id ->
            let
                historyItem =
                    findHistoryItem id model.itemInput.history
            in
                case historyItem of
                    Just item ->
                        ( { model
                            | shoppingList = SUpdate.addItem model.shoppingList item.name
                            , itemInput = IUpdate.toggleSelected model.itemInput id
                          }
                        , Cmd.none
                        )

                    Nothing ->
                        ( model, Cmd.none )

        RemoveHistoryItem id ->
            let
                historyItem =
                    findHistoryItem id model.itemInput.history
            in
                case historyItem of
                    Just item ->
                        ( { model
                            | shoppingList = SUpdate.removeItem model.shoppingList item.id
                            , itemInput = IUpdate.toggleSelected model.itemInput id
                          }
                        , Cmd.none
                        )

                    Nothing ->
                        ( model, Cmd.none )


findHistoryItem : Int -> List HistoryItem -> Maybe HistoryItem
findHistoryItem id history =
    List.filter (\item -> item.id == id) history
        |> List.head
