module Timer exposing (..)


type alias Seconds =
    Int


type Timer
    = Started Seconds
    | Stopped Seconds


getSeconds timer =
    case timer of
        Started seconds ->
            seconds

        Stopped seconds ->
            seconds


stop =
    Stopped << getSeconds


start =
    Started << getSeconds


hasExpired : Timer -> Bool
hasExpired =
    (>) 0 << getSeconds


newTimer =
    Stopped (60 * 6)


showTime : Timer -> String
showTime timer =
    let
        totalSeconds =
            getSeconds timer

        seconds =
            remainderBy 60 totalSeconds

        minutes =
            totalSeconds // 60

        sign =
            if totalSeconds > 0 then
                ""

            else
                "-"
    in
    [ abs minutes, abs seconds ]
        |> List.map String.fromInt
        |> List.map (String.padLeft 2 '0')
        |> String.join ":"
        |> (++) sign
