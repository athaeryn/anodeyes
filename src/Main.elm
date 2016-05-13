port module Anodeyes exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)

import Dial
import Toggle

type Msg
  -- Dials
  = AmpDecay Dial.Msg
  | FilterDecay Dial.Msg
  | Cutoff Dial.Msg
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
  -- envelope
  { ampDecay : Dial.Model
  , filterDecay : Dial.Model
  -- filter
  , cutoff : Dial.Model
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


init : (Model, Cmd Msg)
init =
  let
    model =
      { ampDecay = Dial.Model 0 54 "amp decay"
      , filterDecay = Dial.Model 0 53 "filter decay"
      , cutoff = Dial.Model 0 52 "cutoff"
      , wave = Dial.Model 0 51 "wave"
      , detune = Dial.Model 0 50 "detune"
      , rate = Dial.Model 0 49 "rate"
      , depth = Dial.Model 0 48 "depth"
      , sustain = Toggle.Model 0 64 "sustain" "off" "on"
      , waveBank = Toggle.Model 0 66 "wave bank" "a" "b"
      , lfoDest = Toggle.Model 0 67 "lfo dest" "osc" "filter"
      , octave = Toggle.Model 0 65 "octave" "lo" "hi"
      }
  in
    (model, Cmd.none)


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
        [ img [ src "img/anodeyes.svg", width 300 ] [] ]
    , controlGroup "envelope"
        [ Html.map AmpDecay (Dial.view model.ampDecay)
        , Html.map FilterDecay (Dial.view model.filterDecay)
        , Html.map Sustain (Toggle.view model.sustain)
        ]
    , controlGroup "filter"
        [ Html.map Cutoff (Dial.view model.cutoff) ]
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


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    -- Dials
    AmpDecay msg ->
      let updated = Dial.update msg model.ampDecay
      in ({ model | ampDecay = updated }, sendCC updated)
    FilterDecay msg ->
      let updated = Dial.update msg model.filterDecay
      in ({ model | filterDecay = updated }, sendCC updated)
    Cutoff msg ->
      let updated = Dial.update msg model.cutoff
      in ({ model | cutoff = updated }, sendCC updated)
    Wave msg ->
      let updated = Dial.update msg model.wave
      in ({ model | wave = updated }, sendCC updated)
    Detune msg ->
      let updated = Dial.update msg model.detune
      in ({ model | detune = updated }, sendCC updated)
    Rate msg ->
      let updated = Dial.update msg model.rate
      in ({ model | rate = updated }, sendCC updated)
    Depth msg ->
      let updated = Dial.update msg model.depth
      in ({ model | depth = updated }, sendCC updated)
    -- Toggles
    Sustain msg ->
      let updated = Toggle.update msg model.sustain
      in ({ model | sustain = updated }, sendCC updated)
    WaveBank msg ->
      let updated = Toggle.update msg model.waveBank
      in ({ model | waveBank = updated }, sendCC updated)
    LFODest msg ->
      let updated = Toggle.update msg model.lfoDest
      in ({ model | lfoDest = updated }, sendCC updated)
    Octave msg ->
      let updated = Toggle.update msg model.octave
      in ({ model | octave = updated }, sendCC updated)


port cc : { number : Int, value : Int } -> Cmd msg


sendCC : { a | number : Int, value : Int } -> Cmd msg
sendCC { number, value } =
  cc {number = number, value = value }


main : Program Never
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }

