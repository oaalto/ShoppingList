module Update exposing (update)

import Model exposing (Model, Page(..))
import Model.ShoppingList exposing (ShoppingListItem, ShoppingListModel)
import Model.Edit exposing (EditModel, HistoryItem)
import Message exposing (Msg(..))
import ShoppingList.Update as SUpdate exposing (update, removeBoughtItems, removeAllItems)
import Ports.LocalStorage as LocalStorage
import Json.Decoders.LocalStorageDecoder exposing (decode)
import Json.Encoders.LocalStorageEncoder exposing (encode)
import Page.Edit.Page as EditPage exposing (update)
import Json.Decode as Decode


update : Msg -> Model.Model -> ( Model.Model, Cmd Msg )
update msg model =
    case msg of
        ToggleShoppingListItem name ->
            ( { model | shoppingList = SUpdate.update model.shoppingList name }, Cmd.none )

        UpdateItemInput value ->
            ( { model | itemInput = EditPage.update model.itemInput value }, Cmd.none )

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


loadHistory : EditModel -> List HistoryItem -> EditModel
loadHistory itemInput history =
    { itemInput | history = history }


loadShoppingList : ShoppingListModel -> List ShoppingListItem -> ShoppingListModel
loadShoppingList shoppingListModel shoppingList =
    { shoppingListModel | items = shoppingList }


updateHistory : ShoppingListModel -> EditModel -> EditModel
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


addHistoryItem : EditModel -> HistoryItem -> EditModel
addHistoryItem model historyItem =
    { model | history = historyItem :: model.history }
