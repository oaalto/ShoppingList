module ItemInput.Model exposing (Model, init)

type alias Model =
  { value : String
  }

init : Model
init =
  Model ""
