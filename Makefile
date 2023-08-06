SHELL := /usr/bin/env bash

run:
	bash ./scripts/tvim

run-persist:
	bash ./scripts/tvim --persist

test:
	bash ./utils/ci/run_test.sh "$(TEST)"
