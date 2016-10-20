port module Anodeyes exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes as H exposing (..)
import Html.Events exposing (..)
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
    | CreatePreset
    | ActivatePreset Id


type alias Model =
    { presets : PresetCollection
    , activeId : Int
    , nextId : Int
    }


model : Model
model =
    { presets = Dict.fromList [ ( 0, ( "untitled", Preset.initialModel ) ) ]
    , activeId = 0
    , nextId = 1
    }


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


presetView : ( Id, NamedPreset ) -> Html Msg
presetView ( id, ( name, preset ) ) =
    Html.map (PresetUpdate id) (Preset.view preset)


presetListItemView : Id -> ( Id, NamedPreset ) -> Html Msg
presetListItemView activeId ( id, ( name, preset ) ) =
    li
        [ class
            (if id == activeId then
                "active"
             else
                ""
            )
        , onClick (ActivatePreset id)
        ]
        [ text name ]


presetListView : PresetCollection -> Id -> Html Msg
presetListView presets activeId =
    let
        presetItems =
            presets
                |> Dict.toList
                |> List.map (presetListItemView activeId)
    in
        div [ class "list-container" ]
            [ img [ src "img/anodeyes.svg", class "logo" ] []
            , ul [] presetItems
            , div []
                [ button [ onClick CreatePreset ] [ text "add new" ]
                ]
            ]


view : Model -> Html Msg
view model =
    div [ class "outer" ]
        [ (presetListView model.presets model.activeId)
        , model.presets
            |> Dict.toList
            |> List.filter (\( id, p ) -> id == model.activeId)
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
                        |> Maybe.map (Preset.update msg)
                        |> Maybe.map (\( p, ccMsg ) -> ( p, cc [ ccMsg ] ))
                        |> Maybe.withDefault ( Preset.initialModel, Cmd.none )

                presets =
                    Dict.insert id ( name, updated ) model.presets
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

        CreatePreset ->
            let
                nextId =
                    model.nextId + 1

                newPreset =
                    Dict.get (model.activeId) model.presets
                        |> Maybe.withDefault ( "untitled", Preset.initialModel )

                newModel =
                    { model
                        | activeId = model.nextId
                        , nextId = nextId
                        , presets = Dict.insert model.nextId newPreset model.presets
                    }
            in
                ( newModel, Cmd.none )

        ActivatePreset id ->
            -- FIXME: send the whole preset over MIDI
            ( { model | activeId = id }, Cmd.none )


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
