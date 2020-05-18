module Backend exposing (..)

import Html
import Lamdera exposing (ClientId, SessionId)
import Time
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = subscriptions
        }


subscriptions model =
    Time.every 1000 (always Tick)


init : ( Model, Cmd BackendMsg )
init =
    ( { secondsRemaining = 0
      , timerLengthInSeconds = 60
      , clientIds = []
      , isActive = False
      }
    , Cmd.none
    )


send msg id =
    Lamdera.sendToFrontend id msg


sendToMany msg ids =
    ids
        |> List.map (send msg)
        |> Cmd.batch


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    let
        secondsRemaining =
            model.secondsRemaining - 1

        doNothing =
            ( model, Cmd.none )
    in
    case msg of
        Tick ->
            if model.isActive then
                ( { model | secondsRemaining = secondsRemaining }
                , sendToMany
                    (SecondsRemainingToFrontend secondsRemaining)
                    model.clientIds
                )

            else
                doNothing


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        NoOpToBackend ->
            ( { model | clientIds = clientId :: model.clientIds }
            , Lamdera.sendToFrontend clientId NoOpToFrontend
            )

        ResetTimerBackend ->
            let
                nextModel =
                    { model
                        | secondsRemaining = model.timerLengthInSeconds
                        , isActive = False
                    }
            in
            ( nextModel
            , sendToMany
                (SecondsRemainingToFrontend nextModel.secondsRemaining)
                nextModel.clientIds
            )

        StartTimerBackend ->
            ( { model | isActive = True }
            , Cmd.none
            )
