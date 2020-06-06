module Types exposing (..)

import Lamdera
import Set exposing (Set)
import Timer exposing (..)


type alias FrontendModel =
    { timer : Timer
    }


type alias BackendModel =
    Room


type alias Room =
    { timer : Timer
    , clientIds : Set Lamdera.ClientId
    }


type FrontendMsg
    = NoOpFrontendMsg
    | ResetTimer
    | StartTimer
    | StopTimer


type ToBackend
    = EnterRoom String
    | ResetTimerBackend
    | StartTimerBackend
    | StopTimerBackend


type BackendMsg
    = Tick


type ToFrontend
    = NoOpToFrontend
    | TimerToFrontend Timer
