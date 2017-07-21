module View exposing (view)

import Html exposing (Html, text, div, img, h2)
import Model exposing (Model, Page(..))
import Message exposing (Msg(..))
import ShoppingList.View as SList exposing (view)
import ItemInput.View as IView exposing (view)
import Material
import Material.Layout as Layout
import Material.Scheme
import Material.Button as Button
import Material.Options as Options


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
          { header = [ IView.view model.itemInput model.mdl ]
          , drawer = []
          , tabs = ( [], [] )
          , main = [  ]
          }

viewShoppingListPage : Model -> Html Msg
viewShoppingListPage model =
  Material.Scheme.top <|
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader
        ]
        { header = [ h2 [] [ text "Shopping List", renderEditButton model.mdl ] ]
        , drawer = []
        , tabs = ( [], [] )
        , main = [ viewBody model ]
        }

viewBody : Model -> Html Msg
viewBody model =
  SList.view model.shoppingList

renderEditButton : Material.Model -> Html Msg
renderEditButton mdl =
  Button.render Mdl [0] mdl
    [ Button.raised
    , Button.colored
    , Button.ripple
    , Options.onClick EditMode
    ]
    [ text "Edit"]
