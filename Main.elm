module Anodeyes exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)

import Dial

type Msg
  = Volume Dial.Msg
  | AmpDecay Dial.Msg
  | FilterDecay Dial.Msg
  | Cutoff Dial.Msg
  | Rez Dial.Msg
  | Wave Dial.Msg
  | Detune Dial.Msg
  | Rate Dial.Msg
  | Depth Dial.Msg

type alias Model =
  { volume : Dial.Model
  -- envelope
  , ampDecay : Dial.Model
  , filterDecay : Dial.Model
  -- filter
  , cutoff : Dial.Model
  , rez : Dial.Model
  -- oscilators
  , wave : Dial.Model
  , detune : Dial.Model
  -- LFO
  , rate : Dial.Model
  , depth : Dial.Model
  }


model : Model
model =
  { volume = Dial.Model 0 "volume"
  , ampDecay = Dial.Model 0 "amp decay"
  , filterDecay = Dial.Model 0 "filter decay"
  , cutoff = Dial.Model 0 "cutoff"
  , rez = Dial.Model 0 "rez"
  , wave = Dial.Model 0 "wave"
  , detune = Dial.Model 0 "detune"
  , rate = Dial.Model 0 "rate"
  , depth = Dial.Model 0 "depth"
  }


view : Model -> Html Msg
view model =
  div []
    [ img [ src "anodeyes.svg", width 300 ] []
    , Html.map Volume (Dial.view model.volume)
    , Html.map AmpDecay (Dial.view model.ampDecay)
    , Html.map FilterDecay (Dial.view model.filterDecay)
    , Html.map Cutoff (Dial.view model.cutoff)
    , Html.map Rez (Dial.view model.rez)
    , Html.map Wave (Dial.view model.wave)
    , Html.map Detune (Dial.view model.detune)
    , Html.map Rate (Dial.view model.rate)
    , Html.map Depth (Dial.view model.depth)
    ]


update : Msg -> Model -> Model
update msg model =
  case msg of
    Volume msg ->
      { model | volume = Dial.update msg model.volume }
    AmpDecay msg ->
      { model | ampDecay = Dial.update msg model.ampDecay }
    FilterDecay msg ->
      { model | filterDecay = Dial.update msg model.filterDecay }
    Cutoff msg ->
      { model | cutoff = Dial.update msg model.cutoff }
    Rez msg ->
      { model | rez = Dial.update msg model.rez }
    Wave msg ->
      { model | wave = Dial.update msg model.wave }
    Detune msg ->
      { model | detune = Dial.update msg model.detune }
    Rate msg ->
      { model | rate = Dial.update msg model.rate }
    Depth msg ->
      { model | depth = Dial.update msg model.depth }


main =
  Html.beginnerProgram { model = model, view = view, update = update }

