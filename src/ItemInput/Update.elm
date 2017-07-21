module ItemInput.Update exposing (update)

import ItemInput.Model exposing (Model)

update : Model -> String -> Model
update model value =
  { model | value = value }
