SHELL := /usr/bin/env bash

test:
	bash ./scripts/tvim --testing

run:
	bash ./scripts/tvim

run-persist:
	bash ./scripts/tvim --persist
