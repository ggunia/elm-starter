module Clock.ClockActions exposing (..)
import Time

type Actions
  = Tick Time.Posix
  | AdjustTimeZone Time.Zone
