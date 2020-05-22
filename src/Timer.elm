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


hasExpired : Timer -> Bool
hasExpired =
    (>) 0 << getSeconds


newTimer =
    Stoped (60 * 6)


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
