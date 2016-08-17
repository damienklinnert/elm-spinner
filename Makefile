all: format_all compile_lib compile_simple_example compile_editor_example

format_all:
	elm-format-0.17 --yes .

compile_lib: src/*.elm
	elm make src/* --yes

compile_simple_example:
	cd example/simple && elm make src/Main.elm --yes

compile_editor_example:
	cd example/editor && elm make src/Main.elm --yes