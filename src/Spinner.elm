module Spinner exposing (Direction(..), Config, defaultConfig, view, Model, Msg, update, subscriptions, init)

{-| git remote add origin git@github.com:damienklinnert/elm-spinner.git.

Check the [README for a general introduction into this module](http://package.elm-lang.org/packages/damienklinnert/elm-spinner/latest/).

# The Elm Architecture
@docs Model, Msg, subscriptions, init, update, view

# Custom Spinners
@docs Direction, Config, defaultConfig
-}

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Time exposing (Time)
import AnimationFrame exposing (times)


{-| Contains the current state and the configuration for the spinner.
-}
type alias Model =
    { time : Time
    , cfg : Config
    }


{-| `Msg` messages need to be passed through your application.
-}
type Msg
    = Noop
    | AnimationFrame Time


{-| Add this to your `program`s subscriptions to animate the spinner.
-}
subscriptions : Model -> Sub Msg
subscriptions _ =
    times AnimationFrame


{-| Defines an initial value for the `Model` type using the `defaultConfiguration`.
-}
init : Model
init =
    { time = 0, cfg = defaultConfig }


{-| Accepts `Msg` and `Model` and computes a new `Model`.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            model ! []

        AnimationFrame newTime ->
            { model | time = newTime } ! []


{-| The actual spinner component.
-}
view : Model -> Html Msg
view model =
    div []
        (List.map (\i -> div [ outerStyle model ] [ div [ barStyles model i ] [] ]) [0..model.cfg.lines - 1])


{-| A spinner can spin `Clockwise` or `Counterclockwise`.
-}
type Direction
    = Clockwise
    | Counterclockwise


{-| A type describing how your spinner looks like.

 - `lines`: Number of lines (a value from 5 to 17, default is 13)
 - `length`: line length (a value from 0 to 56, default is 28)
 - `width`: line width (a value from 2 to 52, default is 14)
 - `radius`: distance from origin to beginning of lines (a value from 0 to 84, default is 42)
 - `scale`: scale for the whole spinner (a value from 0 to 5, default is 1)
 - `corners`: roundness of corners (a value from 0 to 1, default is 1)
 - `opacity`: minimum opacity of inactive lines (a value from 0 to 1, default is 0.25)
 - `rotate`: rotate the spinner by some degrees (a value from 0 to 90, default is 0)
 - `direction`: spinner direction (default is Clockwise)
 - `speed`: (a value from 0.5 (slowest), 2.2 (fastest), default is 1)
 - `trail`: how long is the trail after the active line (a value from 10 to 100, default is 60)
 - `translateX`: moves the spinner horizontally (a value from 0 to 100, default is 50)
 - `translateY`: moves the spinner vertically (a value from 0 to 100, default is 50)
 - `shadow`: adds a box shadow (default is True)
 - `hwaccel`: enables hardware acceleration for lines (default is False)

-}
type alias Config =
    { lines : Float
    , length : Float
    , width : Float
    , radius : Float
    , scale : Float
    , corners : Float
    , opacity : Float
    , rotate : Float
    , direction : Direction
    , speed : Float
    , trail : Float
    , translateX : Float
    , translateY : Float
    , shadow : Bool
    , hwaccel : Bool
    }


{-| A default spinner for use in your application.
-}
defaultConfig : Config
defaultConfig =
    { lines = 13
    , length = 28
    , width = 14
    , radius = 42
    , scale = 1
    , corners = 1
    , opacity = 0.25
    , rotate = 0
    , direction = Clockwise
    , speed = 1
    , trail = 60
    , translateX = 50
    , translateY = 50
    , shadow = True
    , hwaccel = False
    }



-- Helpers, those make our spinner look like one


outerStyle : Model -> Html.Attribute Msg
outerStyle model =
    style
        ([ ( "position", "absolute" )
         , ( "top", "calc(" ++ (toString model.cfg.translateY) ++ "%)" )
         , ( "left", (toString model.cfg.translateX) ++ "%" )
         ]
            ++ (if model.cfg.hwaccel then
                    [ ( "transform", "translate3d(0px, 0px, 0px)" ) ]
                else
                    []
               )
        )


barStyles : Model -> Float -> Html.Attribute a
barStyles model n =
    let
        directionBasedDeg =
            if model.cfg.direction == Clockwise then
                (model.cfg.lines - n)
            else
                n

        deg =
            360 / model.cfg.lines * directionBasedDeg + model.cfg.rotate |> toString

        fullBlinkTime =
            1000 / model.cfg.speed

        scaledTrail =
            ceiling (model.cfg.lines * model.cfg.trail / 100) |> toFloat

        movePerLight =
            (n / model.cfg.lines) * fullBlinkTime |> truncate

        lineOpacity =
            (toFloat (1000 - (((truncate model.time) + movePerLight) % (truncate fullBlinkTime)))) / 1000

        trailedOpacity =
            (max 0 ((model.cfg.lines * lineOpacity) - (model.cfg.lines - scaledTrail))) / scaledTrail

        borderRadius =
            model.cfg.corners * model.cfg.width

        baseLinedOpacity =
            max model.cfg.opacity trailedOpacity |> toString
    in
        style
            [ ( "background", "#fff" )
            , ( "height", (toString (model.cfg.width * model.cfg.scale)) ++ "px" )
            , ( "width", "" ++ (toString (model.cfg.length * model.cfg.scale + model.cfg.width)) ++ "px" )
            , ( "position", "absolute" )
            , ( "transform-origin", "left" )
            , ( "transform", "rotate(" ++ deg ++ "deg) translate(" ++ (toString (model.cfg.radius * model.cfg.scale)) ++ "px, 0px)" )
            , ( "border-radius", (toString (borderRadius * model.cfg.scale)) ++ "px" )
            , ( "opacity", baseLinedOpacity )
            , ( "box-shadow"
              , (if model.cfg.shadow then
                    "0 0 4px #000"
                 else
                    "none"
                )
              )
              -- TODO add browser prefixes!
            , ( "-webkit-box-shadow"
              , (if model.cfg.shadow then
                    "0 0 4px #000"
                 else
                    "none"
                )
              )
            ]
