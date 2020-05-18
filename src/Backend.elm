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
    ( { secondsRemaining = 60
      , clientIds = []
      }
    , Cmd.none
    )


send msg id =
    Lamdera.sendToFrontend id msg


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    let
        secondsRemaining =
            model.secondsRemaining - 1
    in
    case msg of
        Tick ->
            ( { model | secondsRemaining = secondsRemaining }
            , model.clientIds
                |> List.map (send (SecondsRemainingToFrontend secondsRemaining))
                |> Cmd.batch
            )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        NoOpToBackend ->
            ( { model | clientIds = clientId :: model.clientIds }
            , Lamdera.sendToFrontend clientId NoOpToFrontend
            )

        ResetTimerBackend ->
            ( { model | secondsRemaining = 60 }, Cmd.none )
