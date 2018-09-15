module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html)
import Html.Attributes exposing (style)
import Spinner


type Msg
    = Noop
    | SpinnerMsg Spinner.Msg


type alias Model =
    { spinner : Spinner.Model
    }


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \model -> Sub.map SpinnerMsg Spinner.subscription
        }


type alias Flags =
    {}


init : Flags -> ( Model, Cmd Msg )
init =
    \_ ->
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

        SpinnerMsg spinnerMsg ->
            let
                spinnerModel =
                    Spinner.update spinnerMsg model.spinner
            in
            ( { model | spinner = spinnerModel }
            , Cmd.none
            )


view : Model -> Browser.Document Msg
view model =
    { title = "Simple Spinner"
    , body = [ Html.div [] [ Spinner.view Spinner.defaultConfig model.spinner ] ]
    }
