module Anodeyes exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)

import Dial

type Msg
  = Volume Dial.Msg

type alias Model =
  { volume : Dial.Model
  }


model =
  { volume = Dial.Model 64 "volume"
  }


view : Model -> Html Msg
view model =
  div []
    [ img [ src "anodeyes.svg", width 300 ] []
    , Html.map Volume (Dial.view model.volume)
    ]


update : Msg -> Model -> Model
update msg model =
  case msg of
    Volume volumeMsg ->
      { model | volume = Dial.update volumeMsg model.volume }


main =
  Html.beginnerProgram { model = model, view = view, update = update }

