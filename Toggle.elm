module Toggle exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

type Msg
  = SetValue Bool

type alias Model =
  { value : Bool
  , label : String
  , leftLabel : String
  , rightLabel : String
  }


view : Model -> Html Msg
view model =
  div []
    [ input [ type' "checkbox", onCheck SetValue, checked model.value ] []
    , h4 [] [ text model.label ]
    ]


update msg model =
  case msg of
    SetValue val ->
      { model | value = val }

