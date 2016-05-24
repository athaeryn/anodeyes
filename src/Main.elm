port module Anodeyes exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes as H exposing (..)
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
    | PresetRename ID String


type alias Model =
    { presets : List NamedPreset
    }


model : Model
model =
    { presets = [ NamedPreset 0 "untitled" Preset.initialModel ] }


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


presetView : NamedPreset -> Html Msg
presetView { id, settings } =
    Html.map (PresetUpdate id) (Preset.view settings)


presetListView : List NamedPreset -> Html Msg
presetListView presets =
    div [ class "list-container" ]
        [ img [ src "img/anodeyes.svg", class "logo" ] []
        , ul []
            [ presets
                |> List.map (\p -> p.name)
                |> List.map text
                |> li []
            ]
        ]


view : Model -> Html Msg
view model =
    div [ class "outer" ]
        [ presetListView model.presets
        , model.presets
            |> List.map presetView
            |> div [ class "anode-container" ]
        ]


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

        PresetRename id name ->
            let
                rename preset =
                    if preset.id == id then
                        { preset | name = name }
                    else
                        preset
            in
                ( { model | presets = (List.map rename model.presets) }, Cmd.none )


port cc : List CCMessage -> Cmd msg


main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
