port module Anodeyes exposing (..)

import Html exposing (..)
import Html.App as Html

import Preset
import Types exposing (CCMessage)


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
        cmd = case ccMessage of
          Just message -> cc message
          Nothing -> Cmd.none
      in
        ({ model | preset = updated }, cmd)


port cc : CCMessage -> Cmd msg


main : Program Never
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }

