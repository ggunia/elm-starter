module Clock.ClockView exposing (view)

import Svg exposing(..)
import Svg.Attributes exposing(..)
import Html exposing (Html)
import Clock.InitialState exposing (Model)
import Clock.ClockActions exposing(Actions)
import Time

view: Model -> Html Actions
view model =
  let
    hour = toFloat (Time.toHour model.zone model.time)
    minute = toFloat (Time.toMinute model.zone model.time)
    second = toFloat (Time.toSecond model.zone model.time)
  in
    svg
      [ viewBox "0 0 400 400"
      , width "400"
      , height "400"
      ]
      [ circle [ cx "200", cy "200", r "120", fill "#1293DB" ] []
      , viewArrow 6 60 (hour / 12)
      , viewArrow 6 90 (minute / 60)
      , viewArrow 3 90 (second / 60)
      ]

viewArrow : Int -> Float -> Float -> Svg Actions
viewArrow width length turns =
  let
    t = 2 * pi * (turns - 0.25)
    x = 200 + length * cos t
    y = 200 + length * sin t
  in
    line
      [ x1 "200"
      , y1 "200"
      , x2 (String.fromFloat x)
      , y2 (String.fromFloat y)
      , stroke "white"
      , strokeWidth (String.fromInt width)
      , strokeLinecap "round"
      ]
      []
