module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html exposing (audio, button, div, input, label, text)
import Html.Attributes as Attr exposing (style)
import Html.Attributes.Extra as ExAttr
import Html.Events as Event exposing (on, onClick)
import Html.Events.Extra exposing (onChange)
import Html.Extra exposing (viewIf)
import Json.Decode as Decode
import Lamdera
import String
import Timer exposing (hasExpired)
import Types exposing (..)
import Url


type alias Model =
    FrontendModel


type alias Msg =
    FrontendMsg


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = always NoOpFrontendMsg
        , onUrlChange = always NoOpFrontendMsg
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = always Sub.none
        , view = view
        }


init : Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init url _ =
    ( { timer = Timer.newTimer
      , volume = 50
      , testSound = False
      }
    , Lamdera.sendToBackend <| EnterRoom url.path
    )


update : FrontendMsg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        send msgToSend =
            ( model, Lamdera.sendToBackend msgToSend )
    in
    case msg of
        NoOpFrontendMsg ->
            ( model, Cmd.none )

        ResetTimer ->
            send ResetTimerBackend

        StartTimer ->
            send StartTimerBackend

        StopTimer ->
            send StopTimerBackend

        ChangeVolume newVolume ->
            ( { model | volume = newVolume }, Cmd.none )

        TestSound ->
            ( { model | testSound = True }, Cmd.none )

        SoundEnded ->
            ( { model | testSound = False }, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd Msg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )

        TimerToFrontend timer ->
            ( { model | timer = timer }, Cmd.none )


view : Model -> Browser.Document Msg
view { timer, volume, testSound } =
    { title = Timer.showTime timer
    , body =
        [ div [ style "text-align" "center", style "padding-top" "40px" ]
            [ div
                [ style "font-family" "sans-serif"
                , style "padding" "40px"
                , style "font-size" "xxx-large"
                ]
                [ text <| Timer.showTime timer ]
            , case timer of
                Timer.Stopped _ ->
                    button [ onClick StartTimer ] [ text "Start" ]

                Timer.Started _ ->
                    button [ onClick StopTimer ] [ text "Stop" ]
            , button [ onClick ResetTimer ] [ text "Reset" ]
            , button [ onClick TestSound ] [ text "Test Sound" ]
            , div []
                [ label [ Attr.for "volume" ] [ text "Volume" ]
                , input
                    [ Attr.type_ "range"
                    , Attr.name "volume"
                    , Attr.min "0"
                    , Attr.max "100"
                    , Attr.value <| String.fromInt volume
                    , onChange
                        (\value ->
                            case String.toInt value of
                                Just newVolume ->
                                    ChangeVolume newVolume

                                Nothing ->
                                    ChangeVolume volume
                        )
                    ]
                    []
                , text <| String.fromInt volume
                ]
            , viewIf ((timer |> hasExpired) || testSound)
                (audio
                    [ Attr.src "blop.mp3"
                    , Attr.autoplay True
                    , ExAttr.volume (toFloat volume / 100.0)
                    , on "ended" (Decode.succeed SoundEnded)
                    ]
                    []
                )
            ]
        ]
    }
