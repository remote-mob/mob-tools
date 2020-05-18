module Types exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Lamdera
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , message : String
    }


type alias BackendModel =
    { secondsRemaining : Int
    , clientIds : List Lamdera.ClientId
    , timerLengthInSeconds : Int
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url
    | NoOpFrontendMsg
    | ResetTimer


type ToBackend
    = NoOpToBackend
    | ResetTimerBackend


type BackendMsg
    = Tick


type ToFrontend
    = NoOpToFrontend
    | SecondsRemainingToFrontend Int
