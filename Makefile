SHELL := /usr/bin/env bash

lint:
	lint-lua lint-sh

lint-lua:
	luacheck *.lua lua/* tests/*

lint-sh:
	shfmt -f . | grep -v jdtls | xargs shellcheck

style: style-lua style-sh

style-lua:
	stylua --config-path .stylua.toml --check .

style-sh:
	shfmt -f . | grep -v jdtls | xargs shfmt -i 2 -ci -bn -l -d

run:
	bash ./scripts/tvim

run-persist:
	bash ./scripts/tvim --persist

test:
	bash ./utils/ci/run_test.sh "$(TEST)"
