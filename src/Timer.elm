module Timer exposing (..)

type alias Seconds =
    Int


type Timer
    = Started Seconds
    | Stoped Seconds


getSeconds timer =
    case timer of
        Started seconds ->
            seconds

        Stoped seconds ->
            seconds


stop =
    Stoped << getSeconds


start =
    Started << getSeconds