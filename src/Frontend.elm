module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html exposing (audio, button, div, text)
import Html.Attributes as Attr exposing (style)
import Html.Events as Event exposing (onClick)
import Lamdera
import Timer
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
init _ _ =
    ( { timer = Timer.newTimer }
    , Lamdera.sendToBackend Connect
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


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd Msg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )

        TimerToFrontend timer ->
            ( { model | timer = timer }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    let
        audioElement =
            if model.timer |> Timer.hasExpired then
                [ audio
                    [ Attr.src "blop.mp3"
                    , Attr.autoplay True
                    ]
                    []
                ]

            else
                []
    in
    { title = Timer.showTime model.timer
    , body =
        [ div [ style "text-align" "center", style "padding-top" "40px" ]
            ([ div
                [ style "font-family" "sans-serif"
                , style "padding" "40px"
                , style "font-size" "xxx-large"
                ]
                [ text <| Timer.showTime model.timer ]
             , button
                [ onClick StartTimer ]
                [ text "Start" ]
             , button
                [ onClick StopTimer ]
                [ text "Stop" ]
             , button
                [ onClick ResetTimer ]
                [ text "Reset" ]
             ]
                ++ audioElement
            )
        ]
    }
