port module Anodeyes exposing (..)

import Html exposing (..)
import Html.App as Html

import Preset
import Types exposing (CCMessage)


type alias ID = Int
type alias PresetWithID = (ID, Preset.Model)

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
    presetView : PresetWithID -> Html Msg
    presetView (id, preset) =
      Html.map (PresetUpdate id) (Preset.view preset)
  in
    div [] (List.map presetView model.presets)


updatePresetWithID : ID -> Preset.Msg -> PresetWithID -> (PresetWithID, Cmd Msg)
updatePresetWithID id msg (presetId, presetModel) =
  if presetId == id then
    let
      (updated, ccMsg) = Preset.update msg presetModel
      cmd = case ccMsg of
        Just message -> cc [message]
        Nothing -> Cmd.none
    in
      ((presetId, updated), cmd)
  else
    ((presetId, presetModel), Cmd.none)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    PresetUpdate id msg ->
      let
        (presets, cmds) =
          model.presets
          |> List.map (updatePresetWithID id msg)
          |> List.unzip
      in
        { model | presets = presets } ! cmds


port cc : List CCMessage -> Cmd msg


main : Program Never
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }

