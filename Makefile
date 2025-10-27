SHELL:=/usr/bin/env bash

BIN_NAME:=newt
BIN_VERSION:=$(shell ./.version.sh)

default: help
.PHONY: help
help: ## Print help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: all
all: clean build ## Clean and build for all supported platforms/architectures

.PHONY: clean
clean: ## Remove build products (./out)
	rm -rf ./out

.PHONY: build
build: ## Build for all supported platforms & architectures to ./out
	mkdir -p out
	cp ./newt ./out/${BIN_NAME}-${BIN_VERSION}-all
	chmod 0555 ./out/${BIN_NAME}-${BIN_VERSION}-all
	sed -i.bak 's/VERSION="<dev>"/VERSION="${BIN_VERSION}"/g' ./out/${BIN_NAME}-${BIN_VERSION}-all
	rm -f ./out/${BIN_NAME}-${BIN_VERSION}-all.bak

.PHONY: package
package: all ## Build binary + .deb package to ./out (requires fpm: https://fpm.readthedocs.io)
	fpm -t deb -v ${BIN_VERSION} -p ./out/${BIN_NAME}-${BIN_VERSION}-all.deb ./out/${BIN_NAME}-${BIN_VERSION}-all=/usr/bin/${BIN_NAME}
