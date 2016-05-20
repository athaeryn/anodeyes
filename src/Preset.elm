module Preset exposing (Model, Msg, initialModel, update, view)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Dial
import Toggle
import Types exposing (CCMessage)


type
    Msg
    -- Dials
    = AmpAttack Dial.Msg
    | AmpDecay Dial.Msg
    | FilterAttack Dial.Msg
    | FilterDecay Dial.Msg
    | Cutoff Dial.Msg
    | Wave Dial.Msg
    | Detune Dial.Msg
    | Rate Dial.Msg
    | Depth Dial.Msg
    | Glide Dial.Msg
    | VCFEnvelope Dial.Msg
      -- Toggles
    | Sustain Toggle.Msg
    | WaveBank Toggle.Msg
    | Octave Toggle.Msg
    | OscWave Toggle.Msg
    | LFODest Toggle.Msg
    | LFORandom Toggle.Msg
    | LFORetrigger Toggle.Msg


type alias Model =
    { ampAttack : Dial.Model
    , ampDecay : Dial.Model
    , filterAttack : Dial.Model
    , filterDecay : Dial.Model
    , cutoff : Dial.Model
    , wave : Dial.Model
    , detune : Dial.Model
    , rate : Dial.Model
    , depth : Dial.Model
    , glide : Dial.Model
    , vcfEnvelope : Dial.Model
    , sustain : Toggle.Model
    , waveBank : Toggle.Model
    , octave : Toggle.Model
    , oscWave : Toggle.Model
    , lfoDest : Toggle.Model
    , lfoRandom : Toggle.Model
    , lfoRetrigger : Toggle.Model
    }


initialModel : Model
initialModel =
    { ampAttack = Dial.Model 0 57 "amp attack"
    , ampDecay = Dial.Model 0 54 "amp decay"
    , filterAttack = Dial.Model 0 58 "filter attack"
    , filterDecay = Dial.Model 0 53 "filter decay"
    , cutoff = Dial.Model 0 52 "cutoff"
    , wave = Dial.Model 0 51 "wave"
    , detune = Dial.Model 0 50 "detune"
    , rate = Dial.Model 0 49 "rate"
    , depth = Dial.Model 0 48 "depth"
    , glide = Dial.Model 0 55 "glide"
    , vcfEnvelope = Dial.Model 0 56 "vcf envelope amount"
    , sustain = Toggle.Model 0 64 "sustain" "off" "on"
    , waveBank = Toggle.Model 0 66 "wave bank" "a" "b"
    , octave = Toggle.Model 0 65 "octave" "lo" "hi"
    , oscWave = Toggle.Model 0 70 "oscillator wave" "pulse" "sawtooth"
    , lfoDest = Toggle.Model 0 67 "lfo dest" "osc" "filter"
    , lfoRandom = Toggle.Model 0 68 "random" "off" "on"
    , lfoRetrigger = Toggle.Model 1 68 "note retrigger" "off" "on"
    }


controlGroup : String -> List (Html Msg) -> Html Msg
controlGroup label html =
    div [ class "control-group" ]
        [ span [ class "control-group__label" ] [ text label ]
        , div [ class "control-group__controls" ] html
        ]


view : Model -> Html Msg
view model =
    div [ class "anode" ]
        [ controlGroup "envelope"
            [ Html.map AmpAttack (Dial.view model.ampAttack)
            , Html.map AmpDecay (Dial.view model.ampDecay)
            , Html.map FilterAttack (Dial.view model.filterAttack)
            , Html.map FilterDecay (Dial.view model.filterDecay)
            , Html.map Sustain (Toggle.view model.sustain)
            ]
        , controlGroup "filter"
            [ Html.map Cutoff (Dial.view model.cutoff) ]
        , controlGroup "oscillators"
            [ Html.map Wave (Dial.view model.wave)
            , Html.map Detune (Dial.view model.detune)
            , Html.map Octave (Toggle.view model.octave)
            , Html.map OscWave (Toggle.view model.oscWave)
            ]
        , controlGroup "lfo"
            [ Html.map Rate (Dial.view model.rate)
            , Html.map Depth (Dial.view model.depth)
            , Html.map LFORandom (Toggle.view model.lfoRandom)
            , Html.map LFORetrigger (Toggle.view model.lfoRetrigger)
            ]
        , controlGroup "misc"
            [ Html.map WaveBank (Toggle.view model.waveBank)
            , Html.map LFODest (Toggle.view model.lfoDest)
            , Html.map Glide (Dial.view model.glide)
            , Html.map VCFEnvelope (Dial.view model.vcfEnvelope)
            ]
        ]


makeCC : { a | number : Int, value : Int } -> CCMessage
makeCC { number, value } =
    { number = number, value = value }


update : Msg -> Model -> ( Model, CCMessage )
update msg model =
    case msg of
        -- Dials
        AmpAttack msg ->
            let
                updated =
                    Dial.update msg model.ampAttack
            in
                ( { model | ampAttack = updated }, makeCC updated )

        AmpDecay msg ->
            let
                updated =
                    Dial.update msg model.ampDecay
            in
                ( { model | ampDecay = updated }, makeCC updated )

        FilterAttack msg ->
            let
                updated =
                    Dial.update msg model.filterAttack
            in
                ( { model | filterAttack = updated }, makeCC updated )

        FilterDecay msg ->
            let
                updated =
                    Dial.update msg model.filterDecay
            in
                ( { model | filterDecay = updated }, makeCC updated )

        Cutoff msg ->
            let
                updated =
                    Dial.update msg model.cutoff
            in
                ( { model | cutoff = updated }, makeCC updated )

        Wave msg ->
            let
                updated =
                    Dial.update msg model.wave
            in
                ( { model | wave = updated }, makeCC updated )

        Detune msg ->
            let
                updated =
                    Dial.update msg model.detune
            in
                ( { model | detune = updated }, makeCC updated )

        Rate msg ->
            let
                updated =
                    Dial.update msg model.rate
            in
                ( { model | rate = updated }, makeCC updated )

        Depth msg ->
            let
                updated =
                    Dial.update msg model.depth
            in
                ( { model | depth = updated }, makeCC updated )

        Glide msg ->
            let
                updated =
                    Dial.update msg model.glide
            in
                ( { model | glide = updated }, makeCC updated )

        VCFEnvelope msg ->
            let
                updated =
                    Dial.update msg model.vcfEnvelope
            in
                ( { model | vcfEnvelope = updated }, makeCC updated )

        -- Toggles
        Sustain msg ->
            let
                updated =
                    Toggle.update msg model.sustain
            in
                ( { model | sustain = updated }, makeCC updated )

        WaveBank msg ->
            let
                updated =
                    Toggle.update msg model.waveBank
            in
                ( { model | waveBank = updated }, makeCC updated )

        Octave msg ->
            let
                updated =
                    Toggle.update msg model.octave
            in
                ( { model | octave = updated }, makeCC updated )

        OscWave msg ->
            let
                updated =
                    Toggle.update msg model.oscWave
            in
                ( { model | oscWave = updated }, makeCC updated )

        LFODest msg ->
            let
                updated =
                    Toggle.update msg model.lfoDest
            in
                ( { model | lfoDest = updated }, makeCC updated )

        LFORandom msg ->
            let
                updated =
                    Toggle.update msg model.lfoRandom
            in
                ( { model | lfoRandom = updated }, makeCC updated )

        LFORetrigger msg ->
            let
                updated =
                    Toggle.update msg model.lfoRetrigger
            in
                ( { model | lfoRetrigger = updated }, makeCC updated )
