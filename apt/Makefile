
ROOT_DIR := $(dir $(lastword $(MAKEFILE_LIST)))../
VERSION_HASH := $(shell md5sum $(ROOT_DIR)/versions.yaml | awk '{print $$1}')

BINARIES_IMAGE := podvm_binaries:$(VERSION_HASH)
BINARIES_FILE := podvm_binaries_$(VERSION_HASH).tar

REGISTRY ?= jamesnelson

CONTAINER_TOOL ?= docker

.PHONY: image

$(BINARIES_FILE):
	docker build -f Dockerfile.binaries -t $(REGISTRY)/$(BINARIES_IMAGE) .


# Could be replaced with better registry tool
registry-cache-binaries:
	-id=$$($(CONTAINER_TOOL) create $(REGISTRY)/$(BINARIES_IMAGE)) && \
	$(CONTAINER_TOOL) cp $$id:/podvm-binaries.tar.gz $(BINARIES_FILE) && \
	docker rm -v $$id

binaries: registry-cache-binaries $(BINARIES_FILE)

image: binaries
