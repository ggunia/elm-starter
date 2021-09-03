module Clock.InitialState exposing (Model, init, update)

import Time
import Task
import Clock.ClockActions exposing (Actions, Actions(..))

type alias Model = { zone: Time.Zone, time: Time.Posix }

init : () -> (Model, Cmd Actions)
init _ =
  ( Model Time.utc (Time.millisToPosix 0)
  , Cmd.batch
      [ Task.perform AdjustTimeZone Time.here
      , Task.perform Tick Time.now
      ]
  )

update : Actions -> Model -> (Model, Cmd Actions)
update msg model =
  case msg of
    Tick newTime ->
      ( { model | time = newTime }, Cmd.none )

    AdjustTimeZone newZone ->
      ( { model | zone = newZone }, Cmd.none )
