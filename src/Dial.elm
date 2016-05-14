module Dial exposing (Model, Msg, update, view)

import Html exposing (..)
import Html.Attributes as H exposing (..)
import Html.Events exposing (onInput)

import String
import Result
import Maybe

type alias Model =
  { value : Int
  , number : Int
  , label : String
  }

type Msg
  = Reset
  | SetValue Int


eventValueToNote : String -> Int
eventValueToNote value =
  String.toInt value
    |> Result.toMaybe
    |> Maybe.withDefault 0


update : Msg -> Model -> Model
update msg model =
  case msg of
    Reset -> { model | value = 0 }
    SetValue v -> { model | value = v }


view : Model -> Html Msg
view model =
  let
    handleInput =
      \v -> SetValue (eventValueToNote v)
  in
    div [ class "control" ]
      [ input
        [ class "control__dial"
        , type' "range"
        , H.min "0"
        , H.max "127"
        , value (toString model.value)
        , onInput handleInput
        ] []
      , span [ class "control__label" ] [ text model.label ]
      ]
