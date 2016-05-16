port module Anodeyes exposing (..)

import Html exposing (..)
import Html.App as Html

import Preset
import Types exposing (CCMessage)


type alias ID = Int


type Msg
  = PresetUpdate ID Preset.Msg


type alias Model =
  { presets : List (ID, Preset.Model)
  }


init : (Model, Cmd Msg)
init =
  ({ presets = [(0, Preset.initialModel)] }, Cmd.none)


view : Model -> Html Msg
view model =
  let
    presetView (id, preset) =
      Html.map (PresetUpdate id) (Preset.view preset)
  in
    div [] (List.map presetView model.presets)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    PresetUpdate id msg ->
      let
        updatePreset (presetId, presetModel) =
          let
            (preset, ccMessage) = if presetId == id then
                                    Preset.update msg presetModel
                                  else
                                    (presetModel, Nothing)
            cmd = case ccMessage of
              Just message -> cc [message]
              Nothing -> Cmd.none
          in
            ((presetId, preset), cmd)
        (presets, cmds) = List.unzip (List.map updatePreset model.presets)
      in
        ({ model | presets = presets }, Cmd.batch cmds)


port cc : List CCMessage -> Cmd msg


main : Program Never
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }

