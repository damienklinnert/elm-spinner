# Changelog

## [Unreleased]
### Changed
- Update package to work with Elm 0.19. 
- Use `Color` package created for Elm 0.19, [avh4/elm-color](https://package.elm-lang.org/packages/avh4/elm-color/latest/), which replaces the previous [elm/color](https://github.com/elm/color) package used pre-Elm 0.19.

### Removed
- Support for Elm 0.18.
- Dependency on package [eskimoblood/elm-color-extra](https://github.com/eskimoblood/elm-color-extra). That package provided a `Color.Convert.colorToCssRgba` function used when rendering the spinner HTML. The new `Color` package provides equivalent functionality directly with `Color.toCssString`.

## [3.0.1] - 2017-02-25

- Supports Elm 0.18.
