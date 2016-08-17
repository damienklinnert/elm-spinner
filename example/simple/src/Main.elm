module Main exposing (..)

import Html
import Html.Attributes exposing (style)
import Html.App exposing (program)
import Spinner


type Msg
    = Noop
    | SpinnerMsg Spinner.Msg


type alias Model =
    { spinner : Spinner.Model
    }


main : Program Never
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


view : Model -> Html.Html Msg
view model =
    Html.div [] [ Spinner.view Spinner.defaultConfig model.spinner ]
