module Update exposing (update)

import Model exposing (Model, Page(..))
import ItemInput.Model as IModel
import ShoppingList.Model as SModel
import Message exposing (Msg(..))
import Material
import ShoppingList.Update as SUpdate exposing (update, removeBoughtItems, removeAllItems)
import ItemInput.Update as IUpdate exposing (update)
import Ports.LocalStorage as LocalStorage
import History.HistoryJson exposing (encode, decode)
import History.HistoryItem exposing (HistoryItem)
import Json.Decode as Decode


update : Msg -> Model.Model -> ( Model.Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model

        ToggleShoppingListItem id ->
            ( { model | shoppingList = SUpdate.update model.shoppingList id }, Cmd.none )

        UpdateItemInput value ->
            ( { model | itemInput = IUpdate.update model.itemInput value }, Cmd.none )

        AddItem ->
            let
                id =
                    model.idCount + 1

                shoppingList =
                    SUpdate.addItem model.shoppingList model.itemInput.value id

                itemInput =
                    updateHistory shoppingList model.itemInput
            in
                ( { model
                    | shoppingList = shoppingList
                    , idCount = id
                    , itemInput = { itemInput | value = "" }
                  }
                , LocalStorage.storageSetItem ( "history", encode itemInput.history )
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
                            | shoppingList = SUpdate.addItem model.shoppingList item.name item.id
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
                        let
                            id =
                                List.foldl checkId 0 historyJson.history
                        in
                            ( { model
                                | itemInput = loadHistory model.itemInput historyJson.history
                                , idCount = id
                              }
                            , Cmd.none
                            )

        ReceiveFromLocalStorage ( _, value ) ->
            ( model, Cmd.none )

        RemoveBoughtItems ->
            ( { model | shoppingList = SUpdate.removeBoughtItems model.shoppingList }, Cmd.none )

        RemoveAllItems ->
            ( { model | shoppingList = SUpdate.removeAllItems model.shoppingList }, Cmd.none )


findHistoryItem : Int -> List HistoryItem -> Maybe HistoryItem
findHistoryItem id history =
    List.filter (\item -> item.id == id) history
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
                addHistoryItem iModel (HistoryItem iModel.value item.id)

            Nothing ->
                iModel


addHistoryItem : IModel.Model -> HistoryItem -> IModel.Model
addHistoryItem model historyItem =
    { model | history = historyItem :: model.history }


checkId : HistoryItem -> Int -> Int
checkId item curId =
    if item.id > curId then
        item.id
    else
        curId
