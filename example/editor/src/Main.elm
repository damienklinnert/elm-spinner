module Main exposing (..)

import Time exposing (Time)
import Html exposing (Html, div, input)
import Html.Attributes as HA
import Html.Events as HE
import Html exposing (program)
import Debug exposing (log)
import String
import Color exposing (Color)
import Dict exposing (Dict)
import Spinner exposing (Direction(..), Config)
import Json.Decode as Json


type Msg
    = Noop
    | SetLines String
    | SetLength String
    | SetWidth String
    | SetRadius String
    | SetScale String
    | SetCorners String
    | SetOpacity String
    | SetRotate String
    | SetDirection String
    | SetColor String
    | SetSpeed String
    | SetTrail String
    | SetTranslateX String
    | SetTranslateY String
    | SetShadow Bool
    | SetHwaccel Bool
    | SpinnerMsg Spinner.Msg


type alias Model =
    { spinner : Spinner.Model
    , spinnerConfig : Spinner.Config
    }


init : ( Model, Cmd Msg )
init =
    ( { spinner = Spinner.init
      , spinnerConfig = Spinner.defaultConfig
      }
    , Cmd.none
    )


updateSpinner : Model -> (x -> Spinner.Config -> Spinner.Config) -> (x -> Model)
updateSpinner model fn =
    \val -> { model | spinnerConfig = fn val model.spinnerConfig }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            model ! []

        SetLines lines ->
            String.toFloat lines
                |> Result.map (updateSpinner model (\lines cfg -> { cfg | lines = lines }))
                >> Result.withDefault model
                >> \model -> model ! []

        SetLength length ->
            String.toFloat length
                |> Result.map (updateSpinner model (\length cfg -> { cfg | length = length }))
                >> Result.withDefault model
                >> \model -> model ! []

        SetWidth width ->
            String.toFloat width
                |> Result.map (updateSpinner model (\width cfg -> { cfg | width = width }))
                >> Result.withDefault model
                >> \model -> model ! []

        SetRadius radius ->
            String.toFloat radius
                |> Result.map (updateSpinner model (\radius cfg -> { cfg | radius = radius }))
                >> Result.withDefault model
                >> \model -> model ! []

        SetScale scale ->
            String.toFloat scale
                |> Result.map (updateSpinner model (\scale cfg -> { cfg | scale = scale }))
                >> Result.withDefault model
                >> \model -> model ! []

        SetCorners corners ->
            String.toFloat corners
                |> Result.map (updateSpinner model (\corners cfg -> { cfg | corners = corners }))
                >> Result.withDefault model
                >> \model -> model ! []

        SetOpacity opacity ->
            String.toFloat opacity
                |> Result.map (updateSpinner model (\opacity cfg -> { cfg | opacity = opacity }))
                >> Result.withDefault model
                >> \model -> model ! []

        SetRotate rotate ->
            String.toFloat rotate
                |> Result.map (updateSpinner model (\rotate cfg -> { cfg | rotate = rotate }))
                >> Result.withDefault model
                >> \model -> model ! []

        SetDirection direction ->
            case direction of
                "Clockwise" ->
                    (updateSpinner model (\direction cfg -> { cfg | direction = direction })) Spinner.Clockwise ! []

                "Counterclockwise" ->
                    (updateSpinner model (\direction cfg -> { cfg | direction = direction })) Spinner.Counterclockwise ! []

                _ ->
                    model ! []

        SetColor colorName ->
            case Dict.get colorName colors of
                Just color ->
                    (updateSpinner model (\color cfg -> { cfg | color = color })) (always color) ! []

                Nothing ->
                    model ! []

        SetSpeed speed ->
            String.toFloat speed
                |> Result.map (updateSpinner model (\speed cfg -> { cfg | speed = speed }))
                >> Result.withDefault model
                >> \model -> model ! []

        SetTrail trail ->
            String.toFloat trail
                |> Result.map (updateSpinner model (\trail cfg -> { cfg | trail = trail }))
                >> Result.withDefault model
                >> \model -> model ! []

        SetTranslateX translateX ->
            String.toFloat translateX
                |> Result.map (updateSpinner model (\translateX cfg -> { cfg | translateX = translateX }))
                >> Result.withDefault model
                >> \model -> model ! []

        SetTranslateY translateY ->
            String.toFloat translateY
                |> Result.map (updateSpinner model (\translateY cfg -> { cfg | translateY = translateY }))
                >> Result.withDefault model
                >> \model -> model ! []

        SetShadow shadow ->
            (updateSpinner model (\translateY cfg -> { cfg | shadow = shadow }) shadow) ! []

        SetHwaccel hwaccel ->
            (updateSpinner model (\translateY cfg -> { cfg | hwaccel = hwaccel }) hwaccel) ! []

        SpinnerMsg msg ->
            let
                spinnerModel =
                    Spinner.update msg model.spinner
            in
                { model | spinner = spinnerModel } ! []


main : Program Never Model Msg
main =
    program
        { init = init
        , subscriptions = (\x -> Sub.map SpinnerMsg Spinner.subscription)
        , update = update
        , view = view
        }


onChange : (String -> msg) -> Html.Attribute msg
onChange handler =
    HE.on "change" <| Json.map handler <| Json.at ["target", "value"] Json.string

view : Model -> Html Msg
view model =
    let
        containerStyles =
            HA.style
                [ ( "position", "relative" )
                , ( "width", "375px" )
                , ( "height", "375px" )
                , ( "background", "#333" )
                , ( "border-radius", "10px" )
                ]
    in
        div [ HA.style [ ( "margin", "20px" ) ] ]
            [ Html.h1 [] [ Html.text "elm-spinner" ]
            , Html.p []
                [ Html.text "Check out "
                , Html.a [ HA.href "http://package.elm-lang.org/packages/damienklinnert/elm-spinner/latest/" ] [ Html.text "the elm package" ]
                , Html.text " and the "
                , Html.a [ HA.href "https://github.com/damienklinnert/elm-spinner/tree/master" ] [ Html.text "the source code" ]
                , Html.text "."
                ]
            , Html.h2 [] [ Html.text "Build your own spinner" ]
            , Html.div [ HA.style [ ( "float", "left" ), ( "width", "375px" ) ] ]
                [ Html.div [ containerStyles ]
                    [ Spinner.view model.spinnerConfig model.spinner
                    ]
                , Html.p [] [ Html.text "Copy and paste this configuration to use this style in your own application:" ]
                , Html.code
                    [ HA.style [ ( "float", "left" ), ( "padding", "10px" ), ( "background", "#eee" ), ( "border-radius", "10px" ) ]
                    ]
                    [ Html.text <| configToString model.spinnerConfig ]
                ]
            , Html.div [ HA.style [ ( "float", "left" ), ( "width", "300px" ), ( "margin-left", "30px" ) ] ]
                [ lineSlider model.spinnerConfig
                , lengthSlider model.spinnerConfig
                , widthSlider model.spinnerConfig
                , radiusSlider model.spinnerConfig
                , scaleSlider model.spinnerConfig
                , cornersSlider model.spinnerConfig
                , opacitySlider model.spinnerConfig
                , rotateSlider model.spinnerConfig
                , directionSelect model.spinnerConfig
                , colorSelect model.spinnerConfig
                , speedSlider model.spinnerConfig
                , trailSlider model.spinnerConfig
                , translateXSlider model.spinnerConfig
                , translateYSlider model.spinnerConfig
                , shadowCheckbox model.spinnerConfig
                , hwaccelCheckbox model.spinnerConfig
                ]
            ]


lineSlider : Spinner.Config -> Html Msg
lineSlider config =
    let
        lines =
            toString config.lines
    in
        Html.p []
            [ Html.text "Lines"
            , input [ HA.type_ "range", HA.min "5", HA.max "17", HA.value lines, HE.onInput SetLines ]
                []
            , Html.text lines
            ]


lengthSlider : Spinner.Config -> Html Msg
lengthSlider config =
    let
        length =
            toString config.length
    in
        Html.p []
            [ Html.text "Length"
            , input [ HA.type_ "range", HA.min "0", HA.max "56", HA.value length, HE.onInput SetLength ]
                []
            , Html.text length
            ]


widthSlider : Spinner.Config -> Html Msg
widthSlider config =
    let
        width =
            toString config.width
    in
        Html.p []
            [ Html.text "Width"
            , input [ HA.type_ "range", HA.min "2", HA.max "52", HA.value width, HE.onInput SetWidth ]
                []
            , Html.text width
            ]


radiusSlider : Spinner.Config -> Html Msg
radiusSlider config =
    let
        radius =
            toString config.radius
    in
        Html.p []
            [ Html.text "Radius"
            , input [ HA.type_ "range", HA.min "0", HA.max "84", HA.value radius, HE.onInput SetRadius ]
                []
            , Html.text radius
            ]


scaleSlider : Spinner.Config -> Html Msg
scaleSlider config =
    let
        scale =
            toString config.scale
    in
        Html.p []
            [ Html.text "Scale"
            , input [ HA.type_ "range", HA.min "0", HA.max "5", HA.value scale, HA.step "0.25", HE.onInput SetScale ]
                []
            , Html.text scale
            ]


cornersSlider : Spinner.Config -> Html Msg
cornersSlider config =
    let
        corners =
            toString config.corners
    in
        Html.p []
            [ Html.text "Corners"
            , input [ HA.type_ "range", HA.min "0", HA.max "1", HA.value corners, HA.step "0.1", HE.onInput SetCorners ]
                []
            , Html.text corners
            ]


opacitySlider : Spinner.Config -> Html Msg
opacitySlider config =
    let
        opacity =
            toString config.opacity
    in
        Html.p []
            [ Html.text "Opacity"
            , input [ HA.type_ "range", HA.min "0", HA.max "1", HA.value opacity, HA.step "0.05", HE.onInput SetOpacity ]
                []
            , Html.text opacity
            ]


rotateSlider : Spinner.Config -> Html Msg
rotateSlider config =
    let
        rotate =
            toString config.rotate
    in
        Html.p []
            [ Html.text "Rotate"
            , input [ HA.type_ "range", HA.min "0", HA.max "90", HA.value rotate, HA.step "1", HE.onInput SetRotate ]
                []
            , Html.text rotate
            ]


directionSelect : Spinner.Config -> Html Msg
directionSelect config =
    let
        direction =
            toString config.direction
    in
        Html.p []
            [ Html.text "Direction"
            , Html.select [ onChange SetDirection ]
                [ Html.option [ HA.value "Clockwise", HA.selected (direction == "Clockwise") ] [ Html.text "Clockwise" ]
                , Html.option [ HA.value "Counterclockwise", HA.selected (direction == "Counterclockwise") ] [ Html.text "Counterclockwise" ]
                ]
            ]

colorSelect : Spinner.Config -> Html Msg
colorSelect config =
    let
        color =
            config.color 0
    in
        Html.p []
            [ Html.text "Color"
            , Html.select [ onChange SetColor ] (List.map (colorSelectOption color) (Dict.toList colors))
            ]


colorSelectOption : Color -> (String, Color) -> Html a
colorSelectOption selected (name, color) =
    Html.option [ HA.value name, HA.selected (selected == color) ] [ Html.text name ]


speedSlider : Spinner.Config -> Html Msg
speedSlider config =
    let
        speed =
            toString config.speed
    in
        Html.p []
            [ Html.text "Speed"
            , input [ HA.type_ "range", HA.min "0.5", HA.max "2.2", HA.value speed, HA.step "0.1", HE.onInput SetSpeed ]
                []
            , Html.text speed
            ]


trailSlider : Spinner.Config -> Html Msg
trailSlider config =
    let
        trail =
            toString config.trail
    in
        Html.p []
            [ Html.text "Trail"
            , input [ HA.type_ "range", HA.min "10", HA.max "100", HA.value trail, HA.step "1", HE.onInput SetTrail ]
                []
            , Html.text trail
            ]


translateXSlider : Spinner.Config -> Html Msg
translateXSlider config =
    let
        translateX =
            toString config.translateX
    in
        Html.p []
            [ Html.text "Translate X"
            , input [ HA.type_ "range", HA.min "0", HA.max "100", HA.value translateX, HA.step "1", HE.onInput SetTranslateX ]
                []
            , Html.text translateX
            ]


translateYSlider : Spinner.Config -> Html Msg
translateYSlider config =
    let
        translateY =
            toString config.translateY
    in
        Html.p []
            [ Html.text "Translate Y"
            , input [ HA.type_ "range", HA.min "0", HA.max "100", HA.value translateY, HA.step "1", HE.onInput SetTranslateY ]
                []
            , Html.text translateY
            ]


shadowCheckbox : Spinner.Config -> Html Msg
shadowCheckbox config =
    let
        shadow =
            config.shadow
    in
        Html.p []
            [ Html.text "Shadow"
            , input [ HA.type_ "checkbox", HA.checked shadow, HE.onCheck SetShadow ]
                []
            ]


hwaccelCheckbox : Spinner.Config -> Html Msg
hwaccelCheckbox config =
    let
        hwaccel =
            config.hwaccel
    in
        Html.p []
            [ Html.text "Hwaccel"
            , input [ HA.type_ "checkbox", HA.checked hwaccel, HE.onCheck SetHwaccel ]
                []
            ]


colors : Dict String Color
colors =
    Dict.fromList
        [ ("white", Color.white)
        , ("red", Color.red)
        , ("orange", Color.orange)
        , ("yellow", Color.lightYellow)
        , ("green", Color.lightGreen)
        , ("blue", Color.lightBlue)
        , ("purple", Color.lightPurple)
        , ("brown", Color.lightBrown)
        ]


configToString : Spinner.Config -> String
configToString config =
    let
        parts =
            [ "lines = " ++ toString config.lines
            , "length = " ++ toString config.length
            , "width = " ++ toString config.width
            , "radius = " ++ toString config.radius
            , "scale = " ++ toString config.scale
            , "corners = " ++ toString config.corners
            , "opacity = " ++ toString config.opacity
            , "rotate = " ++ toString config.rotate
            , "direction = Spinner." ++ toString config.direction
            , "speed = " ++ toString config.speed
            , "trail = " ++ toString config.trail
            , "translateX = " ++ toString config.translateX
            , "translateY = " ++ toString config.translateY
            , "shadow = " ++ toString config.shadow
            , "hwaccel = " ++ toString config.hwaccel
            , "color = always <| " ++ colorToString (config.color 0)
            ]
    in
        "{ " ++ String.join ", " parts ++ " }"


colorToString : Color -> String
colorToString color =
    let
        colorRgb = Color.toRgb color
    in
        String.join " "
          [ "Color.rgba"
          , toString colorRgb.red
          , toString colorRgb.green
          , toString colorRgb.blue
          , toString colorRgb.alpha
          ]
