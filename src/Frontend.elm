module Frontend exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Html
import Html.Attributes as Attr
import Html.Events as Event
import Lamdera
import Types exposing (..)
import Url


type alias Model =
    FrontendModel


app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = always NoOpFrontendMsg
        , onUrlChange = always NoOpFrontendMsg
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \m -> Sub.none
        , view = view
        }


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { secondsRemaining = 0 }
    , Lamdera.sendToBackend Connect
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
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


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        NoOpToFrontend ->
            ( model, Cmd.none )

        SecondsRemainingToFrontend seconds ->
            ( { model | secondsRemaining = seconds }, Cmd.none )


showTime : Int -> String
showTime totalSeconds =
    let
        seconds =
            remainderBy 60 totalSeconds

        minutes =
            totalSeconds // 60

        sign =
            if totalSeconds > 0 then
                ""

            else
                "-"
    in
    [ abs minutes, abs seconds ]
        |> List.map String.fromInt
        |> List.map (String.padLeft 2 '0')
        |> String.join ":"
        |> (++) sign


view : Model -> Browser.Document FrontendMsg
view model =
    let
        audio =
            if model.secondsRemaining < 0 then
                [ Html.audio
                    [ Attr.src "blop.mp3"
                    , Attr.autoplay True
                    ]
                    []
                ]

            else
                []
    in
    { title = ""
    , body =
        [ Html.div [ Attr.style "text-align" "center", Attr.style "padding-top" "40px" ]
            ([ Html.div
                [ Attr.style "font-family" "sans-serif"
                , Attr.style "padding" "40px"
                , Attr.style "font-size" "xxx-large"
                ]
                [ Html.text <| showTime model.secondsRemaining ]
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
