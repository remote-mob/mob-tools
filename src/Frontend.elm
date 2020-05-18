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
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \m -> Sub.none
        , view = view
        }


init : Url.Url -> Nav.Key -> ( Model, Cmd FrontendMsg )
init url key =
    ( { key = key
      , message = ""
      }
    , Lamdera.sendToBackend NoOpToBackend
    )


update : FrontendMsg -> Model -> ( Model, Cmd FrontendMsg )
update msg model =
    let
        send msgToSend =
            ( model, Lamdera.sendToBackend msgToSend )
    in
    case msg of
        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Cmd.batch [ Nav.pushUrl model.key (Url.toString url) ]
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            ( model, Cmd.none )

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
            ( { model | message = "got message" }, Cmd.none )

        SecondsRemainingToFrontend seconds ->
            ( { model | message = showTime seconds }, Cmd.none )


showTime : Int -> String
showTime totalSeconds =
    let
        seconds =
            modBy 60 totalSeconds

        minutes =
            totalSeconds // 60
    in
    [ minutes, seconds ]
        |> List.map String.fromInt
        |> List.map (String.padLeft 2 '0')
        |> String.join ":"


view model =
    { title = ""
    , body =
        [ Html.div [ Attr.style "text-align" "center", Attr.style "padding-top" "40px" ]
            [ Html.img [ Attr.src "https://lamdera.app/lamdera-logo-black.png", Attr.width 150 ] []
            , Html.div
                [ Attr.style "font-family" "sans-serif"
                , Attr.style "padding-top" "40px"
                ]
                [ Html.text model.message ]
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
        ]
    }
