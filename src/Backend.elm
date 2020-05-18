module Backend exposing (..)

import Html
import Lamdera exposing (ClientId, SessionId)
import Time
import Types exposing (..)
import Timer exposing (..)


type alias Model =
    BackendModel


type alias Msg =
    BackendMsg


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = subscriptions
        }


subscriptions model =
    Time.every 1000 (always Tick)


newTimer =
    Stoped (60 * 6)


init : ( Model, Cmd Msg )
init =
    ( { timer = newTimer
      , clientIds = []
      }
    , Cmd.none
    )


send msg id =
    Lamdera.sendToFrontend id msg


sendToMany msg ids =
    ids
        |> List.map (send msg)
        |> Cmd.batch


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        doNothing =
            ( model, Cmd.none )
    in
    case msg of
        Tick ->
            case model.timer of
                Stoped _ ->
                    doNothing

                Started seconds ->
                    let
                        secondsRemaining =
                            seconds - 1
                    in
                    ( { model | timer = Started secondsRemaining }
                    , sendToMany
                        (SecondsRemainingToFrontend secondsRemaining)
                        model.clientIds
                    )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd Msg )
updateFromFrontend sessionId clientId msg model =
    let
        secondsRemaining =
            getSeconds model.timer
    in
    case msg of
        Connect ->
            ( { model | clientIds = clientId :: model.clientIds }
            , Lamdera.sendToFrontend
                clientId
                (SecondsRemainingToFrontend secondsRemaining)
            )

        ResetTimerBackend ->
            let
                nextModel =
                    { model | timer = newTimer }
            in
            ( nextModel
            , sendToMany
                (SecondsRemainingToFrontend <| getSeconds nextModel.timer)
                nextModel.clientIds
            )

        StartTimerBackend ->
            ( { model | timer = start model.timer }
            , Cmd.none
            )

        StopTimerBackend ->
            ( { model | timer = stop model.timer }
            , Cmd.none
            )
