module Main exposing (..)

import Html
import Html.Attributes exposing (style)
import Html exposing (program)
import Color exposing (Color, rgb)
import Color.Gradient exposing (gradient)
import Color.Interpolate exposing (Space(RGB))
import Spinner exposing (Direction(..))


type Msg
    = Noop
    | SpinnerMsg Spinner.Msg


type alias Model =
    { spinner : Spinner.Model
    }


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = (\model -> Sub.map SpinnerMsg Spinner.subscription)
        }


init : ( Model, Cmd Msg )
init =
    { spinner = Spinner.init } ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            model ! []

        SpinnerMsg msg ->
            let
                spinnerModel =
                    Spinner.update msg model.spinner
            in
                { model | spinner = spinnerModel } ! []


palette : List Color
palette =
  [ Color.green
  , Color.lightGreen
  , Color.lightYellow
  , Color.red
  , Color.purple
  , Color.lightBlue
  , Color.blue
  ]


rainbowGradient : List Color
rainbowGradient =
  gradient RGB palette 13


rainbowColor : Float -> Color
rainbowColor n =
  Maybe.withDefault Color.white (List.head (List.drop (floor n % 13) rainbowGradient))


config =
  { color = rainbowColor
  , lines = 13
  , length = 0
  , width = 36
  , radius = 6
  , scale = 0.75
  , corners = 1
  , opacity = 0.05
  , rotate = 23
  , direction = Clockwise
  , speed = 1
  , trail = 100
  , translateX = 50
  , translateY = 50
  , shadow = False
  , hwaccel = False
  }


view : Model -> Html.Html Msg
view model =
    Html.div [] [ Spinner.view config model.spinner ]
