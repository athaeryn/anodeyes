module Toggle exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

type Msg
  = SetValue Bool

type alias Model =
  { value : Bool
  , number : Int
  , label : String
  , leftLabel : String
  , rightLabel : String
  }


view : Model -> Html Msg
view model =
  div [ class "control" ]
    [ div [ class "control__toggle" ]
        [ span [] [ text model.leftLabel ]
        , input
            [ class "control__toggle-switch"
            , type' "checkbox"
            , onCheck SetValue
            , checked model.value
            ] []
        , span [] [ text model.rightLabel ]
        ]
    , span [ class "control__label" ] [ text model.label ]
    ]


update msg model =
  case msg of
    SetValue val ->
      { model | value = val }

