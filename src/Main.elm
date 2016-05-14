port module Anodeyes exposing (..)

import Html exposing (..)
import Html.App as Html

import Preset


type Msg
  = PresetUpdate Preset.Msg


type alias Model =
  { preset : Preset.Model
  }


init : (Model, Cmd Msg)
init =
  ({ preset = Preset.initialModel }, Cmd.none)


view : Model -> Html Msg
view model =
  div [] [ Html.map PresetUpdate (Preset.view model.preset) ]


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    PresetUpdate msg ->
      let
        (updated, ccMessage) = Preset.update msg model.preset
      in
        ({ model | preset = updated }, cc ccMessage)


port cc : { number : Int, value : Int } -> Cmd msg


main : Program Never
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }

