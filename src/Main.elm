port module Anodeyes exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes as H exposing (..)
import Preset
import Types exposing (CCMessage)
import Dict


type alias Id =
    Int


type alias Name =
    String


type alias NamedPreset =
    ( Name, Preset.Model )


type alias PresetCollection =
    Dict.Dict Id NamedPreset


type Msg
    = PresetUpdate Id Preset.Msg
    | PresetRename Id Name


type alias Model =
    { presets : PresetCollection
    , nextId : Int
    }


model : Model
model =
    { presets = Dict.fromList [( 0, ("untitled", Preset.initialModel ) )]
    , nextId = 1
    }


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


presetView : (Name, Preset.Model) -> Html Msg
presetView (name, preset) =
    -- FIXME get an actual id
    Html.map (PresetUpdate 0) (Preset.view preset)


presetListView : PresetCollection -> Html Msg
presetListView presets =
    div [ class "list-container" ]
        [ img [ src "img/anodeyes.svg", class "logo" ] []
        , ul []
            [ presets
                |> Dict.toList
                |> List.unzip
                |> snd
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
            |> List.unzip
            |> snd
            |> List.map presetView
            |> div [ class "anode-container" ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PresetUpdate id msg ->
            let
                preset =
                    Dict.get id model.presets
                name =
                    Dict.get id model.presets
                    |> Maybe.map fst
                    |> Maybe.withDefault "untitled"
                ( updated, cmd ) =
                    preset
                    |> Maybe.map snd
                    |> Maybe.map ( Preset.update msg )
                    |> Maybe.map (\(p, ccMsg) -> (p, cc [ccMsg]))
                    |> Maybe.withDefault ( Preset.initialModel, Cmd.none )
                presets =
                    Dict.insert id (name, updated) model.presets
            in
                ( { model | presets = presets }, cmd )


        PresetRename id name ->
            let
                preset : NamedPreset
                preset =
                    model.presets
                    |> Dict.get id
                    |> Maybe.withDefault ( "untitled", Preset.initialModel )

                updatedPresets : PresetCollection
                updatedPresets =
                    model.presets
                    |> Dict.remove id
                    |> Dict.insert id preset
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
