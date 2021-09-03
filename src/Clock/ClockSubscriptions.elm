module Clock.ClockSubscriptions exposing (subscriptions)

import Time
import Clock.InitialState exposing (Model)
import Clock.ClockActions exposing (Actions, Actions(..))

subscriptions : Model -> Sub Actions
subscriptions _ =
  Time.every 1000 Tick
