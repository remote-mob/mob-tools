module Types exposing (..)

import Lamdera
import Set exposing (Set)
import Timer exposing (..)


type alias Volume =
    Int


type alias FrontendModel =
    { timer : Timer
    , volume : Volume
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
    | ChangeVolume Volume


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
