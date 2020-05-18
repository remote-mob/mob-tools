module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Lamdera
import Url exposing (Url)
import Timer exposing (..)


type alias FrontendModel =
    { secondsRemaining : Int
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
    | SecondsRemainingToFrontend Int
