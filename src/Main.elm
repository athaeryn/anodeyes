port module Anodeyes exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes as H exposing (..)
import Preset
import Types exposing (CCMessage)
import Dict


type alias ID =
    Int


type alias PresetCollection =
    Dict.Dict String Preset.Model


type Msg
    = PresetUpdate String Preset.Msg
    | PresetRename String String


type alias Model =
    { presets : PresetCollection
    }


model : Model
model =
    { presets = Dict.fromList [("untitled", Preset.initialModel )] }


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


presetView : (String, Preset.Model) -> Html Msg
presetView (name, preset) =
    Html.map (PresetUpdate name) (Preset.view preset)


presetListView : PresetCollection -> Html Msg
presetListView presets =
    div [ class "list-container" ]
        [ img [ src "img/anodeyes.svg", class "logo" ] []
        , ul []
            [ presets
                |> Dict.toList
                |> List.map (\(name, p) -> name)
                |> List.map text
                |> li []
            ]
        ]


view : Model -> Html Msg
view model =
    div [ class "outer" ]
        [ presetListView model.presets
        , model.presets
            |> Dict.toList
            |> List.map presetView
            |> div [ class "anode-container" ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PresetUpdate name msg ->
            let
                preset =
                    Dict.get name model.presets
                ( updated, cmd ) =
                    preset
                    |> Maybe.map ( Preset.update msg )
                    |> Maybe.map (\(p, ccMsg) -> (p, cc [ccMsg]))
                    |> Maybe.withDefault ( Preset.initialModel, Cmd.none )
                presets =
                    Dict.insert name updated model.presets
            in
                ( { model | presets = presets }, cmd )


        PresetRename name newName ->
            let
                preset =
                    model.presets
                    |> Dict.get name
                    |> Maybe.withDefault Preset.initialModel
                updatedPresets =
                    model.presets
                    |> Dict.remove name
                    |> Dict.insert newName preset
            in
                ( { model | presets = updatedPresets }, Cmd.none )


port cc : List CCMessage -> Cmd msg


-- port loadPresets : ({presets : List (String, Preset.Model)} -> msg) -> Sub msg


main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
