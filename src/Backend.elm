module Backend exposing (..)

import Lamdera exposing (ClientId, SessionId)
import Set
import Time
import Timer exposing (..)
import Types exposing (..)


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


subscriptions _ =
    Time.every 1000 (always Tick)


init : ( Model, Cmd Msg )
init =
    ( { timer = newTimer
      , clientIds = Set.empty
      }
    , Cmd.none
    )


send msg id =
    Lamdera.sendToFrontend id msg


broadCastTimer model =
    sendToMany (TimerToFrontend model.timer) model.clientIds


sendToMany msg ids =
    ids
        |> Set.toList
        |> List.map (send msg)
        |> Cmd.batch


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        doNothing =
            ( model, Cmd.none )

        timer =
            Timer.addSeconds 1 model.timer

        nextModel =
            { model | timer = timer }

        incrementTimer =
            ( nextModel, broadCastTimer nextModel )
    in
    case msg of
        Tick ->
            case model.timer of
                Stopped _ ->
                    doNothing

                Started _ ->
                    incrementTimer


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd Msg )
updateFromFrontend _ clientId msg model =
    let
        nextModel =
            case msg of
                Connect ->
                    { model
                        | clientIds = Set.insert clientId model.clientIds
                    }

                ResetTimerBackend ->
                    { model | timer = newTimer }

                StartTimerBackend ->
                    { model | timer = start model.timer }

                StopTimerBackend ->
                    { model | timer = stop model.timer }
    in
    ( nextModel, broadCastTimer nextModel )
