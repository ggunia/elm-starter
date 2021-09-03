module Clock.Clock exposing (..)

import Browser
import Clock.ClockView exposing(view)
import Clock.InitialState exposing (init)
import Clock.InitialState exposing (update)
import Clock.ClockSubscriptions exposing (subscriptions)
import Clock.ClockActions exposing (Actions)

main : Program () Clock.InitialState.Model Actions
main = Browser.element
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions}
