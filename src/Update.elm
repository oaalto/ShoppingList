module Update exposing (update)

import Model exposing (Model, Page(..))
import ItemInput.Model as IModel
import ShoppingList.Model as SModel
import Message exposing (Msg(..))
import ShoppingList.Update as SUpdate exposing (update, removeBoughtItems, removeAllItems)
import ItemInput.Update as IUpdate exposing (update)
import Ports.LocalStorage as LocalStorage
import History.HistoryJson exposing (encode, decode)
import History.HistoryItem exposing (HistoryItem)
import Json.Decode as Decode


update : Msg -> Model.Model -> ( Model.Model, Cmd Msg )
update msg model =
    case msg of
        ToggleShoppingListItem name ->
            ( { model | shoppingList = SUpdate.update model.shoppingList name }, Cmd.none )

        UpdateItemInput value ->
            ( { model | itemInput = IUpdate.update model.itemInput value }, Cmd.none )

        AddItem ->
            let
                shoppingList =
                    SUpdate.addItem model.shoppingList model.itemInput.value

                itemInput =
                    updateHistory shoppingList model.itemInput
            in
                ( { model
                    | shoppingList = shoppingList
                    , itemInput = { itemInput | value = "" }
                  }
                , LocalStorage.storageSetItem ( "history", encode itemInput.history )
                )

        EditMode ->
            ( { model | currentPage = EditListPage }, Cmd.none )

        ListMode ->
            ( { model | currentPage = ShoppingListPage }, Cmd.none )

        AddHistoryItem name ->
            let
                historyItem =
                    findHistoryItem name model.itemInput.history
            in
                case historyItem of
                    Just item ->
                        ( { model
                            | shoppingList = SUpdate.addItem model.shoppingList item.name
                          }
                        , Cmd.none
                        )

                    Nothing ->
                        ( model, Cmd.none )

        RemoveHistoryItem name ->
            let
                historyItem =
                    findHistoryItem name model.itemInput.history
            in
                case historyItem of
                    Just item ->
                        ( { model
                            | shoppingList = SUpdate.removeItem model.shoppingList item.name
                          }
                        , Cmd.none
                        )

                    Nothing ->
                        ( model, Cmd.none )

        LoadFromStorage ->
            ( model, LocalStorage.storageGetItem "history" )

        ReceiveFromLocalStorage ( "history", value ) ->
            let
                historyResult =
                    Decode.decodeValue decode value
            in
                case historyResult of
                    Err msg ->
                        ( model, Cmd.none )

                    Ok historyJson ->
                        ( { model
                            | itemInput = loadHistory model.itemInput historyJson.history
                          }
                        , Cmd.none
                        )

        ReceiveFromLocalStorage ( _, value ) ->
            ( model, Cmd.none )

        RemoveBoughtItems ->
            ( { model | shoppingList = SUpdate.removeBoughtItems model.shoppingList }, Cmd.none )

        RemoveAllItems ->
            ( { model | shoppingList = SUpdate.removeAllItems model.shoppingList }, Cmd.none )


findHistoryItem : String -> List HistoryItem -> Maybe HistoryItem
findHistoryItem name history =
    List.filter (\item -> item.name == name) history
        |> List.head


loadHistory : IModel.Model -> List HistoryItem -> IModel.Model
loadHistory itemInput history =
    { itemInput | history = history }


updateHistory : SModel.Model -> IModel.Model -> IModel.Model
updateHistory sModel iModel =
    let
        addedItem =
            List.head sModel.items
    in
        case addedItem of
            Just item ->
                addHistoryItem iModel (HistoryItem iModel.value)

            Nothing ->
                iModel


addHistoryItem : IModel.Model -> HistoryItem -> IModel.Model
addHistoryItem model historyItem =
    { model | history = historyItem :: model.history }
