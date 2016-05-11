module Anodeyes exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes as H exposing (..)
import Html.Events exposing (onInput)

import String
import Result
import Maybe

type alias Note = Int

type alias Model = Note

type Msg
  = Reset
  | SetValue Note


eventValueToNote : String -> Note
eventValueToNote value =
  String.toInt value
    |> Result.toMaybe
    |> Maybe.withDefault 0


noteView : Model -> Html Msg
noteView model =
  let
    handleInput =
      \v -> SetValue (eventValueToNote v)
  in
    div []
      [ h2 [] [ text (toString model) ]
      , input
          [ type' "range",
            H.min "0",
            H.max "127",
            value (toString model),
            onInput handleInput
          ] []
      ]


model : Model
model = 0


update : Msg -> Model -> Model
update msg model =
  case msg of
    Reset -> 0
    SetValue value -> value


view : Model -> Html Msg
view model =
  div []
    [ img [ src "anodeyes.svg", width 400 ] []
    , noteView model
    ]


main =
  Html.beginnerProgram { model = model, view = view, update = update }

