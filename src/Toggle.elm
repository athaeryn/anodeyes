module Toggle exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type Msg
    = SetValue Bool


type alias Model =
    { value : Int
    , number : Int
    , label : String
    , leftLabel : String
    , rightLabel : String
    }


valueAsBool : Model -> Bool
valueAsBool model =
    model.value == 127


boolToValue : Bool -> Int
boolToValue bool =
    if bool then
        127
    else
        0


view : Model -> Html Msg
view model =
    div [ class "control" ]
        [ div [ class "control__toggle" ]
            [ span [] [ text model.leftLabel ]
            , input
                [ class "control__toggle-switch"
                , type' "checkbox"
                , onCheck SetValue
                , checked (valueAsBool model)
                ]
                []
            , span [] [ text model.rightLabel ]
            ]
        , span [ class "control__label" ] [ text model.label ]
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetValue val ->
            { model | value = boolToValue val }
