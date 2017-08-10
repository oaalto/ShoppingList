module Update exposing (update)

import Model exposing (Model, Page(..))
import ItemInput.Model as IModel
import ShoppingList.Model as SModel exposing (ShoppingListItem)
import Message exposing (Msg(..))
import ShoppingList.Update as SUpdate exposing (update, removeBoughtItems, removeAllItems)
import ItemInput.Update as IUpdate exposing (update)
import Ports.LocalStorage as LocalStorage
import Json.Decoders.LocalStorageDecoder exposing (decode)
import Json.Encoders.LocalStorageEncoder exposing (encode)
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
                , LocalStorage.storageSetItem ( "ShoppingList", encode itemInput.history shoppingList.items )
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
                        let
                            shoppingList =
                                SUpdate.removeItem model.shoppingList item.name
                        in
                            ( { model
                                | shoppingList = shoppingList
                              }
                            , LocalStorage.storageSetItem ( "ShoppingList", encode model.itemInput.history shoppingList.items )
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
                        let
                            shoppingList =
                                SUpdate.removeItem model.shoppingList item.name
                        in
                            ( { model
                                | shoppingList = shoppingList
                              }
                            , LocalStorage.storageSetItem ( "ShoppingList", encode model.itemInput.history shoppingList.items )
                            )

                    Nothing ->
                        ( model, Cmd.none )

        LoadFromStorage ->
            ( model, LocalStorage.storageGetItem "ShoppingList" )

        ReceiveFromLocalStorage ( "ShoppingList", value ) ->
            let
                localStorageResult =
                    Decode.decodeValue decode value
            in
                case localStorageResult of
                    Err msg ->
                        ( model, Cmd.none )

                    Ok localStorageJson ->
                        ( { model
                            | itemInput = loadHistory model.itemInput localStorageJson.history
                            , shoppingList = loadShoppingList model.shoppingList localStorageJson.shoppingList
                          }
                        , Cmd.none
                        )

        ReceiveFromLocalStorage ( _, value ) ->
            ( model, Cmd.none )

        RemoveBoughtItems ->
            let
                shoppingList =
                    SUpdate.removeBoughtItems model.shoppingList
            in
                ( { model | shoppingList = shoppingList }
                , LocalStorage.storageSetItem ( "ShoppingList", encode model.itemInput.history shoppingList.items )
                )

        RemoveAllItems ->
            let
                shoppingList =
                    SUpdate.removeAllItems model.shoppingList
            in
                ( { model | shoppingList = shoppingList }
                , LocalStorage.storageSetItem ( "ShoppingList", encode model.itemInput.history shoppingList.items )
                )


findHistoryItem : String -> List HistoryItem -> Maybe HistoryItem
findHistoryItem name history =
    List.filter (\item -> item.name == name) history
        |> List.head


loadHistory : IModel.Model -> List HistoryItem -> IModel.Model
loadHistory itemInput history =
    { itemInput | history = history }


loadShoppingList : SModel.Model -> List ShoppingListItem -> SModel.Model
loadShoppingList shoppingListModel shoppingList =
    { shoppingListModel | items = shoppingList }


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
