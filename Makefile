QUAY_USERNAME ?= shovanmaity
LATEST_TAG ?= ci
IMAGE_TAG ?= $(shell git rev-parse --short HEAD)

.PHONY: crd-gen
crd-gen:
	rm -rf config/crd
	controller-gen crd:crdVersions=v1 paths=./client/apis/demo.io/v1
	controller-gen object paths=./client/apis/demo.io/v1

##
.PHONY: rsync-client-image
rsync-client-image:
	docker build -t ghcr.io/$(QUAY_USERNAME)/rsync-client:$(LATEST_TAG) -f docker/client/rsync/Dockerfile .
	docker build -t ghcr.io/$(QUAY_USERNAME)/rsync-client:$(IMAGE_TAG) -f docker/client/rsync/Dockerfile .

.PHONY: push-rsync-client-image
push-rsync-client-image: rsync-client-image
	docker push ghcr.io/$(QUAY_USERNAME)/rsync-client:$(LATEST_TAG)
	docker push ghcr.io/$(QUAY_USERNAME)/rsync-client:$(IMAGE_TAG)

##
.PHONY: rsync-daemon-image
rsync-daemon-image:
	docker build -t ghcr.io/$(QUAY_USERNAME)/rsync-daemon:$(LATEST_TAG) -f docker/server/rsync/Dockerfile .
	docker build -t ghcr.io/$(QUAY_USERNAME)/rsync-daemon:$(IMAGE_TAG) -f docker/server/rsync/Dockerfile .

.PHONY: push-rsync-daemon-image
push-rsync-daemon-image: rsync-daemon-image
	docker push ghcr.io/$(QUAY_USERNAME)/rsync-daemon:$(LATEST_TAG)
	docker push ghcr.io/$(QUAY_USERNAME)/rsync-daemon:$(IMAGE_TAG)

##
.PHONY: rsync-populator-binary
rsync-populator-binary:
	mkdir -p bin
	rm -rf bin/rsync-populator
	CGO_ENABLED=0 go build -o bin/rsync-populator app/populator/rsync/*

.PHONY: rsync-populator-image
rsync-populator-image: rsync-populator-binary
	docker build -t ghcr.io/$(QUAY_USERNAME)/rsync-populator:$(LATEST_TAG) -f docker/populator/rsync/Dockerfile .
	docker build -t ghcr.io/$(QUAY_USERNAME)/rsync-populator:$(IMAGE_TAG) -f docker/populator/rsync/Dockerfile .

.PHONY: push-rsync-populator-image
push-rsync-populator-image: rsync-populator-image
	docker push ghcr.io/$(QUAY_USERNAME)/rsync-populator:$(LATEST_TAG)
	docker push ghcr.io/$(QUAY_USERNAME)/rsync-populator:$(IMAGE_TAG)

##
.PHONY: pv-populator-binary
pv-populator-binary:
	mkdir -p bin
	rm -rf bin/pv-populator
	CGO_ENABLED=0 go build -o bin/pv-populator app/populator/pv/*

.PHONY: pv-populator-image
pv-populator-image: pv-populator-binary
	docker build -t ghcr.io/$(QUAY_USERNAME)/pv-populator:$(LATEST_TAG) -f docker/populator/pv/Dockerfile .
	docker build -t ghcr.io/$(QUAY_USERNAME)/pv-populator:$(IMAGE_TAG) -f docker/populator/pv/Dockerfile .

.PHONY: push-pv-populator-image
push-pv-populator-image: pv-populator-image
	docker push ghcr.io/$(QUAY_USERNAME)/pv-populator:$(LATEST_TAG)
	docker push ghcr.io/$(QUAY_USERNAME)/pv-populator:$(IMAGE_TAG)

##
.PHONY: volume-rename-binary
volume-rename-binary:
	mkdir -p bin
	rm -rf bin/volume-rename
	CGO_ENABLED=0 go build -o bin/volume-rename app/volume-rename/*

.PHONY: volume-rename-image
volume-rename-image: volume-rename-binary
	docker build -t ghcr.io/$(QUAY_USERNAME)/volume-rename:$(LATEST_TAG) -f docker/volume-rename/Dockerfile .
	docker build -t ghcr.io/$(QUAY_USERNAME)/volume-rename:$(IMAGE_TAG) -f docker/volume-rename/Dockerfile .

.PHONY: push-volume-rename-image
push-volume-rename-image: volume-rename-image
	docker push ghcr.io/$(QUAY_USERNAME)/volume-rename:$(LATEST_TAG)
	docker push ghcr.io/$(QUAY_USERNAME)/volume-rename:$(IMAGE_TAG)
##
.PHONY: volume-copy-binary
volume-copy-binary:
	mkdir -p bin
	rm -rf bin/volume-copy
	CGO_ENABLED=0 go build -o bin/volume-copy app/volume-copy/*

.PHONY: volume-copy-image
volume-copy-image: volume-copy-binary
	docker build -t ghcr.io/$(QUAY_USERNAME)/volume-copy:$(LATEST_TAG) -f docker/volume-copy/Dockerfile .
	docker build -t ghcr.io/$(QUAY_USERNAME)/volume-copy:$(IMAGE_TAG) -f docker/volume-copy/Dockerfile .

.PHONY: push-volume-copy-image
push-volume-copy-image: volume-copy-image
	docker push ghcr.io/$(QUAY_USERNAME)/volume-copy:$(LATEST_TAG)
	docker push ghcr.io/$(QUAY_USERNAME)/volume-copy:$(IMAGE_TAG)

##
.PHONY: images
images: rsync-client-image rsync-daemon-image rsync-populator-image pv-populator-image volume-rename-image volume-copy-image

.PHONY: push-images
push-images: push-rsync-client-image push-rsync-daemon-image push-rsync-populator-image push-pv-populator-image push-volume-rename-image push-volume-copy-image
