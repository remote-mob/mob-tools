module Backend exposing (..)

import Lamdera exposing (ClientId, SessionId)
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

                        timer =
                            Started secondsRemaining
                    in
                    ( { model | timer = timer }
                    , sendToMany
                        (TimerToFrontend timer)
                        model.clientIds
                    )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd Msg )
updateFromFrontend _ clientId msg model =
    case msg of
        Connect ->
            ( { model | clientIds = clientId :: List.filter ((==) clientId) model.clientIds }
            , Lamdera.sendToFrontend
                clientId
                (TimerToFrontend model.timer)
            )

        ResetTimerBackend ->
            let
                nextModel =
                    { model | timer = newTimer }
            in
            ( nextModel
            , sendToMany
                (TimerToFrontend newTimer)
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
