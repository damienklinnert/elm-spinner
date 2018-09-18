# elm-spinner

A highly configurable, efficiently rendered spinner component.

![Example](https://github.com/damienklinnert/elm-spinner/raw/master/example/elm-spinner.gif)

The `Spinner` module exposes the `Model` and `Msg` type as well as an `update` and `view` function, all ready
to with the Elm Architecture in your application.


**Features**:

- No images, no external CSS
- Highly configurable ([try the interactive spinner editor](https://damienklinnert.github.io/elm-spinner/))
- Resolution independent (looks great on Retina!!)
- Efficient animations thanks to `window.requestAnimationFrame`
- Works in Chrome, Safari, Firefox from IE >= 10


**Reference**:

- [license](https://github.com/damienklinnert/elm-spinner/issues/blob/master/LICENSE)
- [bug tracker](https://github.com/damienklinnert/elm-spinner/issues)
- [source code](https://github.com/damienklinnert/elm-spinner)
- [documentation](http://package.elm-lang.org/packages/damienklinnert/elm-spinner/latest/)
- [changelog](https://github.com/damienklinnert/elm-spinner/blob/master/CHANGELOG.md)


## Quickstart

This section will walk you through your very first steps with the `Spinner` module.
At the end, you'll have a good understanding of how to use this module.

You can find two complete examples in the `example/` folder:

- A [simple, bare bones integration](https://github.com/damienklinnert/elm-spinner/tree/master/example/simple)
  of a spinner in `example/simple/`
- A [visual spinner editor](https://damienklinnert.github.io/elm-spinner/),
  allowing you to make your own spinner in  `example/editor/`

If you're not yet familiar with [The Elm Architecture](http://guide.elm-lang.org/architecture/), give it a quick read.
It will help you to understand how the spinner works.


### Preparation: Import the module

Run the following command in the root directory of your project:

```bash
elm package install damienklinnert/elm-spinner

```

And then import the `Spinner` module at the top of a module like this:

```elm
import Spinner
```

Now you're ready to wire up everything!


### Subscription

Since our spinner is animated, we'll need to add a `subscription` to our `program`:

```elm
main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = (\model -> Sub.map SpinnerMsg Spinner.subscription)
        }
```


### Update Function

You might have already noticed the `SpinnerMsg` in the previous example. Since our spinner is animated, it will send
messages of type `Spinner.Msg` wrapped inside a `SpinnerMsg` to our update function.

Now it's up to us to forward those messages to the `Spinner.update` function:

```elm
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
```


### Model

The previous example already referenced `model.spinner`, which is of type `Spinner.Model`. The `Spinner.update` function
takes care of keeping that up to date for us. However we still need to add `Spinner.Model` to our applications model.

```elm
type alias Model =
    { spinner : Spinner.Model
    }
```

Now where `Spinner.Model` is part of your model, you also need to properly initialise it. You can use `Spinner.init` to get started quickly:

```elm
init : ( Model, Cmd Msg )
init =
    { spinner = Spinner.init } ! []
```


### View

Now, last but not least, you can add the spinner to your application's view like this:

```elm
view : Model -> Html.Html Msg
view model =
    Html.div [] [ Spinner.view Spinner.defaultConfig model.spinner ]


```

Et Voilà, you should now have an animated spinner in your application.

**Note**: If you dislike the default spinner stype, you can make your own. Check the [spin module docs](http://package.elm-lang.org/packages/damienklinnert/elm-spinner/latest/) for more info.


### What's next?

- Check the [bare bones integration](https://github.com/damienklinnert/elm-spinner/tree/master/example/simple)
- [Make your own spinner](https://damienklinnert.github.io/elm-spinner/)
- Check out the full documentation for the [Spin module](http://package.elm-lang.org/packages/damienklinnert/elm-spinner/latest/)


## Credits

This module is highly inspired by [spin.js from Felix Gnass](http://spin.js.org).
