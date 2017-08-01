module View exposing (view)

import Html exposing (Html, text, div, img, h3, span)
import Model exposing (Model, Page(..))
import Message exposing (Msg(..))
import ShoppingList.View as SList exposing (view, renderHeader)
import ItemInput.View as IView exposing (renderHeader)
import Material.Layout as Layout
import Material.Scheme


view : Model -> Html Msg
view model =
    case model.currentPage of
        ShoppingListPage ->
            viewShoppingListPage model

        EditListPage ->
            viewEditListPage model


viewEditListPage : Model -> Html Msg
viewEditListPage model =
    Material.Scheme.top <|
        Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            ]
            { header = [ IView.renderHeader model.itemInput model.mdl ]
            , drawer = []
            , tabs = ( [], [] )
            , main = [ IView.renderBody model.itemInput model.mdl model.shoppingList.items ]
            }


viewShoppingListPage : Model -> Html Msg
viewShoppingListPage model =
    Material.Scheme.top <|
        Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            ]
            { header = [ SList.renderHeader model.shoppingList model.mdl ]
            , drawer = []
            , tabs = ( [], [] )
            , main = [ viewBody model ]
            }


viewBody : Model -> Html Msg
viewBody model =
    SList.view model.shoppingList
