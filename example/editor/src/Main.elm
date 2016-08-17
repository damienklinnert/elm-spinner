module Main exposing (..)

import Time exposing (Time)
import Html exposing (Html, div, input)
import Html.Attributes as HA
import Html.Events as HE
import Html.App exposing (program)
import Debug exposing (log)
import String
import Spinner exposing (Direction(..), Config)


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
                ( spinnerModel, spinnerCmd ) =
                    Spinner.update msg model.spinner
            in
                { model | spinner = spinnerModel } ! [ Cmd.map SpinnerMsg spinnerCmd ]


main : Program Never
main =
    program
        { init = init
        , subscriptions = (\x -> Sub.map SpinnerMsg <| Spinner.subscriptions x.spinner)
        , update = update
        , view = view
        }


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
        div []
            [ Html.h1 [] [ Html.text "elm-spinner" ]
            , Html.div []
                [ Html.h2 [] [ Html.text "Example" ]
                , Html.div [ containerStyles ]
                    [ Html.App.map SpinnerMsg <| Spinner.view model.spinnerConfig model.spinner
                    ]
                ]
            , Html.div []
                [ lineSlider model.spinnerConfig
                , lengthSlider model.spinnerConfig
                , widthSlider model.spinnerConfig
                , radiusSlider model.spinnerConfig
                , scaleSlider model.spinnerConfig
                , cornersSlider model.spinnerConfig
                , opacitySlider model.spinnerConfig
                , rotateSlider model.spinnerConfig
                , directionSelect model.spinnerConfig
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
            , input [ HA.type' "range", HA.min "5", HA.max "17", HA.value lines, HE.onInput SetLines ]
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
            , input [ HA.type' "range", HA.min "0", HA.max "56", HA.value length, HE.onInput SetLength ]
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
            , input [ HA.type' "range", HA.min "2", HA.max "52", HA.value width, HE.onInput SetWidth ]
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
            , input [ HA.type' "range", HA.min "0", HA.max "84", HA.value radius, HE.onInput SetRadius ]
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
            , input [ HA.type' "range", HA.min "0", HA.max "5", HA.value scale, HA.step "0.25", HE.onInput SetScale ]
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
            , input [ HA.type' "range", HA.min "0", HA.max "1", HA.value corners, HA.step "0.1", HE.onInput SetCorners ]
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
            , input [ HA.type' "range", HA.min "0", HA.max "1", HA.value opacity, HA.step "0.05", HE.onInput SetOpacity ]
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
            , input [ HA.type' "range", HA.min "0", HA.max "90", HA.value rotate, HA.step "1", HE.onInput SetRotate ]
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
            , Html.select [ HE.onInput SetDirection ]
                [ Html.option [ HA.value "Clockwise", HA.selected (direction == "Clockwise") ] [ Html.text "Clockwise" ]
                , Html.option [ HA.value "Counterclockwise", HA.selected (direction == "Counterclockwise") ] [ Html.text "Counterclockwise" ]
                ]
            ]


speedSlider : Spinner.Config -> Html Msg
speedSlider config =
    let
        speed =
            toString config.speed
    in
        Html.p []
            [ Html.text "Speed"
            , input [ HA.type' "range", HA.min "0.5", HA.max "2.2", HA.value speed, HA.step "0.1", HE.onInput SetSpeed ]
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
            , input [ HA.type' "range", HA.min "10", HA.max "100", HA.value trail, HA.step "1", HE.onInput SetTrail ]
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
            , input [ HA.type' "range", HA.min "0", HA.max "100", HA.value translateX, HA.step "1", HE.onInput SetTranslateX ]
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
            , input [ HA.type' "range", HA.min "0", HA.max "100", HA.value translateY, HA.step "1", HE.onInput SetTranslateY ]
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
            , input [ HA.type' "checkbox", HA.checked shadow, HE.onCheck SetShadow ]
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
            , input [ HA.type' "checkbox", HA.checked hwaccel, HE.onCheck SetHwaccel ]
                []
            ]
