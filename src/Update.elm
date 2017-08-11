module Update exposing (update)

import Model exposing (Model, Page(..))
import Model.ShoppingList exposing (ShoppingListItem, ShoppingListModel)
import Model.Edit exposing (EditModel, HistoryItem)
import Message exposing (Msg(..))
import Ports.LocalStorage as LocalStorage
import Json.Decoders.LocalStorageDecoder exposing (decode)
import Json.Encoders.LocalStorageEncoder exposing (encode)
import Page.Edit.Page as EditPage exposing (update)
import Page.ShoppingList.Page as ShoppingListPage exposing (update, addItem, removeItem)
import Page.ShoppingList.Message as ShoppingListMsg exposing (ShoppingListExternalMessage(..), ShoppingListMessage(..))
import Json.Decode as Decode


update : Msg -> Model.Model -> ( Model.Model, Cmd Msg )
update msg model =
    case msg of
        ShoppingList shoppingListMsg ->
            updateShoppingList model shoppingListMsg

        UpdateItemInput value ->
            ( { model | itemInput = EditPage.update model.itemInput value }, Cmd.none )

        AddItem ->
            let
                shoppingList =
                    ShoppingListPage.addItem model.shoppingList model.itemInput.value

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
                                ShoppingListPage.addItem model.shoppingList item.name
                        in
                            ( { model
                                | shoppingList = shoppingList
                              }
                            , LocalStorage.storageSetItem
                                ( "ShoppingList"
                                , encode model.itemInput.history shoppingList.items
                                )
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
                                ShoppingListPage.removeItem model.shoppingList item.name
                        in
                            ( { model
                                | shoppingList = shoppingList
                              }
                            , LocalStorage.storageSetItem
                                ( "ShoppingList"
                                , encode model.itemInput.history shoppingList.items
                                )
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


updateShoppingList : Model -> ShoppingListMessage -> ( Model, Cmd Msg )
updateShoppingList model shoppingListMsg =
    let
        ( shoppingList, externalMsg ) =
            ShoppingListPage.update shoppingListMsg model.shoppingList
    in
        case externalMsg of
            NoOp ->
                ( { model | shoppingList = shoppingList }, Cmd.none )

            SaveToStorage ->
                ( { model | shoppingList = shoppingList }
                , LocalStorage.storageSetItem ( "ShoppingList", encode model.itemInput.history shoppingList.items )
                )
