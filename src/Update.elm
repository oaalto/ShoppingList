module Update exposing (update)

import Model exposing (Model, Page(..))
import Model.ShoppingList exposing (ShoppingListItem, ShoppingListModel)
import Model.Edit exposing (EditModel, HistoryItem)
import Message exposing (Msg(..))
import Ports.LocalStorage as LocalStorage
import Json.Decoders.LocalStorageDecoder exposing (decode)
import Json.Encoders.LocalStorageEncoder exposing (encode)
import Page.Edit.Page as EditPage exposing (update, addItem)
import Page.ShoppingList.Page as ShoppingListPage exposing (update, addItem, removeItem)
import Page.ShoppingList.Message as ShoppingListMsg exposing (ShoppingListExternalMessage(..), ShoppingListMessage(..))
import Json.Decode as Decode


update : Msg -> Model.Model -> ( Model.Model, Cmd Msg )
update msg model =
    case msg of
        ShoppingList shoppingListMsg ->
            updateShoppingList model shoppingListMsg

        UpdateItemInput value ->
            ( { model | editModel = EditPage.update model.editModel value }, Cmd.none )

        AddItem ->
            let
                shoppingList =
                    ShoppingListPage.addItem model.shoppingList model.editModel.value

                editModel =
                    EditPage.addItem model.editModel
            in
                ( { model
                    | shoppingList = shoppingList
                    , editModel = editModel
                  }
                , LocalStorage.storageSetItem ( "ShoppingList", encode editModel.history shoppingList.items )
                )

        EditMode ->
            ( { model | currentPage = EditListPage }, Cmd.none )

        ListMode ->
            ( { model | currentPage = ShoppingListPage }, Cmd.none )

        AddHistoryItem name ->
            let
                historyItem =
                    findHistoryItem name model.editModel.history
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
                                , encode model.editModel.history shoppingList.items
                                )
                            )

                    Nothing ->
                        ( model, Cmd.none )

        RemoveHistoryItem name ->
            let
                historyItem =
                    findHistoryItem name model.editModel.history
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
                                , encode model.editModel.history shoppingList.items
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
                            | editModel = loadHistory model.editModel localStorageJson.history
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
loadHistory editModel history =
    { editModel | history = history }


loadShoppingList : ShoppingListModel -> List ShoppingListItem -> ShoppingListModel
loadShoppingList shoppingListModel shoppingList =
    { shoppingListModel | items = shoppingList }


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
                , LocalStorage.storageSetItem ( "ShoppingList", encode model.editModel.history shoppingList.items )
                )
