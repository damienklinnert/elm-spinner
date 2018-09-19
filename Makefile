all: format_all compile_lib compile_simple_example compile_editor_example

format_all:
	elm-format --yes .

compile_lib: src/*.elm
	elm make src/*

compile_simple_example:
	cd example/simple && elm make src/Main.elm

compile_editor_example:
	cd example/editor && elm make src/Main.elm
