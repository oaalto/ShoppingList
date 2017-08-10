module Page.Edit.Update exposing (update)

import Model.Edit exposing (EditModel)


update : EditModel -> String -> EditModel
update model value =
    { model | value = value }
