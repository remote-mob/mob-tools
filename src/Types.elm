module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Lamdera
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , secondsRemaining : Int
    }


type alias BackendModel =
    { secondsRemaining : Int
    , isActive : Bool
    , clientIds : List Lamdera.ClientId
    , timerLengthInSeconds : Int
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
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
