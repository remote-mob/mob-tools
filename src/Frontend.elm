module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html
import Html.Attributes as Attr
import Html.Events as Event
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
        blop =
            Html.audio
                [ Attr.src "blop.mp3"
                , Attr.autoplay True
                ]
                []

        audio =
            if Timer.getSeconds model.timer < 0 then
                [ blop ]

            else
                []
    in
    { title = Timer.showTime model.timer
    , body =
        [ Html.div [ Attr.style "text-align" "center", Attr.style "padding-top" "40px" ]
            ([ Html.div
                [ Attr.style "font-family" "sans-serif"
                , Attr.style "padding" "40px"
                , Attr.style "font-size" "xxx-large"
                ]
                [ Html.text <| Timer.showTime model.timer ]
             , Html.button
                [ Event.onClick StartTimer ]
                [ Html.text "Start" ]
             , Html.button
                [ Event.onClick StopTimer ]
                [ Html.text "Stop" ]
             , Html.button
                [ Event.onClick ResetTimer ]
                [ Html.text "Reset" ]
             ]
                ++ audio
            )
        ]
    }
