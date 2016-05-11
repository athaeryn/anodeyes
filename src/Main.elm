module Anodeyes exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)

import Dial
import Toggle

type Msg
  -- Dials
  = Volume Dial.Msg
  | AmpDecay Dial.Msg
  | FilterDecay Dial.Msg
  | Cutoff Dial.Msg
  | Rez Dial.Msg
  | Wave Dial.Msg
  | Detune Dial.Msg
  | Rate Dial.Msg
  | Depth Dial.Msg
  -- Toggles
  | Sustain Toggle.Msg
  | WaveBank Toggle.Msg
  | LFODest Toggle.Msg
  | Octave Toggle.Msg


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
  -- toggles
  , sustain : Toggle.Model
  , waveBank : Toggle.Model
  , lfoDest : Toggle.Model
  , octave : Toggle.Model
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

  , sustain = Toggle.Model False "sustain" "off" "on"
  , waveBank = Toggle.Model False "wave bank" "a" "b"
  , lfoDest = Toggle.Model False "lfo dest" "osc" "filter"
  , octave = Toggle.Model False "octave" "lo" "hi"
  }


controlGroup : String -> List (Html Msg) -> Html Msg
controlGroup label html =
  div
    [ class "control-group" ]
    [ span [ class "control-group__label"] [ text label ]
    , div [ class "control-group__controls" ] html
    ]


view : Model -> Html Msg
view model =
  div [ class "anode" ]
    [ div [ class "anode__header" ]
        [ img [ src "img/anodeyes.svg", width 300 ] []
        , Html.map Volume (Dial.view model.volume)
        ]
    , controlGroup "envelope"
        [ Html.map AmpDecay (Dial.view model.ampDecay)
        , Html.map FilterDecay (Dial.view model.filterDecay)
        , Html.map Sustain (Toggle.view model.sustain)
        ]
    , controlGroup "filter"
        [ Html.map Cutoff (Dial.view model.cutoff)
        , Html.map Rez (Dial.view model.rez)
        ]
    , controlGroup "oscilators"
        [ Html.map Wave (Dial.view model.wave)
        , Html.map Detune (Dial.view model.detune)
        , Html.map Octave (Toggle.view model.octave)
        ]
    , controlGroup "lfo"
        [ Html.map Rate (Dial.view model.rate)
        , Html.map Depth (Dial.view model.depth)
        ]
    , controlGroup "misc"
      [ Html.map WaveBank (Toggle.view model.waveBank)
      , Html.map LFODest (Toggle.view model.lfoDest)
      ]
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
    Sustain msg ->
      { model | sustain = Toggle.update msg model.sustain }
    WaveBank msg ->
      { model | waveBank = Toggle.update msg model.waveBank }
    LFODest msg ->
      { model | lfoDest = Toggle.update msg model.lfoDest }
    Octave msg ->
      { model | octave = Toggle.update msg model.octave }


main =
  Html.beginnerProgram { model = model, view = view, update = update }

