module Types exposing (..)

import Lamdera
import Timer exposing (..)


type alias FrontendModel =
    { timer : Timer
    }


type alias BackendModel =
    { timer : Timer
    , clientIds : List Lamdera.ClientId
    }


type FrontendMsg
    = NoOpFrontendMsg
    | ResetTimer
    | StartTimer
    | StopTimer


type ToBackend
    = Connect
    | ResetTimerBackend
    | StartTimerBackend
    | StopTimerBackend


type BackendMsg
    = Tick


type ToFrontend
    = NoOpToFrontend
    | TimerToFrontend Timer
