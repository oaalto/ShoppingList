module ItemInput.Update exposing (update, clearInput)

import ItemInput.Model exposing (Model)

update : Model -> String -> Model
update model value =
  { model | value = value }


clearInput : Model -> Model
clearInput model =
  { model | value = "" }
