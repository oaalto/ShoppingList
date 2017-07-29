module View exposing (view)

import Html exposing (Html, text, div, img, h3, span)
import Html.Attributes exposing (class)
import Model exposing (Model, Page(..))
import Message exposing (Msg(..))
import ShoppingList.View as SList exposing (view)
import ItemInput.View as IView exposing (renderHeader)
import Material
import Material.Layout as Layout
import Material.Scheme
import Material.Button as Button
import Material.Options as Options
import Material.Icon as Icon
import Material.Menu as Menu
import MdlIds exposing (Id(..), toInt)


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
            { header = [ IView.renderHeader model.itemInput model.mdl model.shoppingList.items ]
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
            { header =
                [ h3 [ class "header" ]
                    [ text "Shopping List"
                    , renderEditButton model.mdl
                    , renderSettingsButton model.mdl
                    ]
                ]
            , drawer = []
            , tabs = ( [], [] )
            , main = [ viewBody model ]
            }


viewBody : Model -> Html Msg
viewBody model =
    SList.view model.shoppingList


renderEditButton : Material.Model -> Html Msg
renderEditButton mdl =
    span [ class "edit-button" ]
        [ Button.render Mdl
            [ toInt EditButton ]
            mdl
            [ Button.fab
            , Button.colored
            , Button.ripple
            , Options.onClick EditMode
            ]
            [ Icon.i "add" ]
        ]


renderSettingsButton : Material.Model -> Html Msg
renderSettingsButton mdl =
    span [ class "settings-button" ]
        [ Menu.render Mdl
            [ toInt SettingsButton ]
            mdl
            [ Menu.bottomRight ]
            [ Menu.item
                [ Menu.onSelect RemoveBoughtItems ]
                [ text "Remove Marked" ]
            , Menu.item
                [ Menu.onSelect RemoveAllItems ]
                [ text "Remove All" ]
            ]
        ]
