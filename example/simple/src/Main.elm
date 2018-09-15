module Main exposing (Model, Msg(..), init, main, update, view)

import Html exposing (program)
import Html.Attributes exposing (style)
import Spinner


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
        , subscriptions = \model -> Sub.map SpinnerMsg Spinner.subscription
        }


init : ( Model, Cmd Msg )
init =
    ( { spinner = Spinner.init }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model
            , Cmd.none
            )

        SpinnerMsg msg ->
            let
                spinnerModel =
                    Spinner.update msg model.spinner
            in
            ( { model | spinner = spinnerModel }
            , Cmd.none
            )


view : Model -> Html.Html Msg
view model =
    Html.div [] [ Spinner.view Spinner.defaultConfig model.spinner ]
