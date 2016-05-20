port module Anodeyes exposing (..)

import Html exposing (..)
import Html.App as Html
import Preset
import Types exposing (CCMessage)


type alias ID =
    Int


type alias NamedPreset =
    { id : ID
    , name : String
    , settings : Preset.Model
    }


type Msg
    = PresetUpdate ID Preset.Msg


type alias Model =
    { presets : List NamedPreset
    }


init : ( Model, Cmd Msg )
init =
    ( { presets = [ NamedPreset 0 "untitled" Preset.initialModel ] }, Cmd.none )


presetView : NamedPreset -> Html Msg
presetView { id, settings } =
    Html.map (PresetUpdate id) (Preset.view settings)


view : Model -> Html Msg
view model =
    model.presets
        |> List.map presetView
        |> div []


updatePresetWithID : ID -> Preset.Msg -> NamedPreset -> ( NamedPreset, Cmd Msg )
updatePresetWithID id msg preset =
    if preset.id == id then
        let
            ( updated, ccMsg ) =
                Preset.update msg preset.settings
        in
            ( { preset | settings = updated }, cc [ ccMsg ] )
    else
        ( preset, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PresetUpdate id msg ->
            let
                ( presets, cmds ) =
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
