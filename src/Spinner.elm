module Spinner exposing (Direction(..), Config, defaultConfig, view, Model, Msg, update, subscription, init)

{-| A highly configurable, efficiently rendered spinner component.

Check the [README for a general introduction into this module](http://package.elm-lang.org/packages/damienklinnert/elm-spinner/latest/).

# The Elm Architecture
@docs Model, Msg, subscription, init, update, view

# Custom Spinners
@docs Direction, Config, defaultConfig
-}

import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Time exposing (Time)
import Color exposing (Color, white)
import Color.Convert exposing (colorToCssRgba)
import AnimationFrame exposing (times)


{-| Contains the current state for the spinner.
-}
type Model
    = Model Time


{-| `Msg` messages need to be passed through your application.
-}
type Msg
    = Noop
    | AnimationFrame Time


{-| Add this to your `program`s subscriptions to animate the spinner.
-}
subscription : Sub Msg
subscription =
    times AnimationFrame


{-| Defines an initial value for the `Model` type.
-}
init : Model
init =
    Model 0


{-| Accepts `Msg` and `Model` and computes a new `Model`.
-}
update : Msg -> Model -> Model
update msg (Model time) =
    case msg of
        Noop ->
            (Model time)

        AnimationFrame newTime ->
            (Model newTime)


{-| The actual spinner component.
-}
view : Config -> Model -> Html msg
view cfg (Model time) =
    let
        range = List.range 0 ((floor cfg.lines) - 1) |> List.map toFloat
    in
        div []
            (List.map (\i -> div [ outerStyle cfg ] [ div [ barStyles cfg time i ] [] ]) range)


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
 - `color`: determines the color for each line based on an index parameter (default is `always Color.white`)

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
    , color : Float -> Color
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
    , color = always white
    }



-- Helpers, those make our spinner look like one


outerStyle : Config -> Html.Attribute msg
outerStyle cfg =
    style
        ([ ( "position", "absolute" )
         , ( "top", "calc(" ++ (toString cfg.translateY) ++ "%)" )
         , ( "left", (toString cfg.translateX) ++ "%" )
         ]
            ++ (if cfg.hwaccel then
                    [ ( "transform", "translate3d(0px, 0px, 0px)" ) ]
                else
                    []
               )
        )


barStyles : Config -> Float -> Float -> Html.Attribute a
barStyles cfg time n =
    let
        directionBasedDeg =
            if cfg.direction == Clockwise then
                (cfg.lines - n)
            else
                n

        deg =
            360 / cfg.lines * directionBasedDeg + cfg.rotate |> toString

        fullBlinkTime =
            1000 / cfg.speed

        scaledTrail =
            ceiling (cfg.lines * cfg.trail / 100) |> toFloat

        movePerLight =
            (n / cfg.lines) * fullBlinkTime |> truncate

        lineOpacity =
            (toFloat (1000 - (((truncate time) + movePerLight) % (truncate fullBlinkTime)))) / 1000

        trailedOpacity =
            (max 0 ((cfg.lines * lineOpacity) - (cfg.lines - scaledTrail))) / scaledTrail

        borderRadius =
            cfg.corners * cfg.width / 2

        baseLinedOpacity =
            max cfg.opacity trailedOpacity |> toString
    in
        style
            [ ( "background", colorToCssRgba (cfg.color n) )
            , ( "height", (toString (cfg.width * cfg.scale)) ++ "px" )
            , ( "width", "" ++ (toString (cfg.length * cfg.scale + cfg.width)) ++ "px" )
            , ( "position", "absolute" )
            , ( "transform-origin", "left" )
            , ( "transform", "rotate(" ++ deg ++ "deg) translate(" ++ (toString (cfg.radius * cfg.scale)) ++ "px, 0px)" )
            , ( "border-radius", (toString (borderRadius * cfg.scale)) ++ "px" )
            , ( "opacity", baseLinedOpacity )
            , ( "box-shadow"
              , (if cfg.shadow then
                    "0 0 4px #000"
                 else
                    "none"
                )
              )
              -- TODO add browser prefixes!
            , ( "-webkit-box-shadow"
              , (if cfg.shadow then
                    "0 0 4px #000"
                 else
                    "none"
                )
              )
            ]
