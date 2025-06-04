DOCKER_REPOSITORY = thomisus/mediamtx
REGISTRY = ghcr.io

github:
	$(eval VERSION := $(shell git describe --tags | tr -d v))

	docker login ghcr.io -u $(DOCKER_USER) -p $(DOCKER_PASSWORD)

	docker buildx rm builder 2>/dev/null || true
	docker buildx create --name=builder

	docker build --builder=builder \
	-f docker/ffmpeg-rpi.Dockerfile . \
	--platform=linux/arm/v6,linux/arm/v7,linux/arm64 \
	-t $(REGISTRY)/$(DOCKER_REPOSITORY):ffmpeg-rpi-$(VERSION) \
	-t $(REGISTRY)/$(DOCKER_REPOSITORY):ffmpeg-rpi \
	--push

	docker build --builder=builder \
	-f docker/rpi.Dockerfile . \
	--platform=linux/arm/v6,linux/arm/v7,linux/arm64 \
	-t $(REGISTRY)/$(DOCKER_REPOSITORY):rpi-$(VERSION) \
	-t $(REGISTRY)/$(DOCKER_REPOSITORY):rpi \
	--push

	docker build --builder=builder \
	-f docker/ffmpeg.Dockerfile . \
	--platform=linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64 \
	-t $(REGISTRY)/$(DOCKER_REPOSITORY):ffmpeg-$(VERSION) \
	-t $(REGISTRY)/$(DOCKER_REPOSITORY):ffmpeg \
	--push

	docker build --builder=builder \
	-f docker/standard.Dockerfile . \
	--platform=linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64 \
	-t $(REGISTRY)/$(DOCKER_REPOSITORY):$(VERSION) \
	-t $(REGISTRY)/$(DOCKER_REPOSITORY):latest \
	--push

	docker build --builder=builder \
	-f docker/ffmpeg-hardware.Dockerfile . \
	--platform=linux/amd64 \
	-t $(REGISTRY)/$(DOCKER_REPOSITORY):ffmpeg-hardware-$(VERSION) \
	-t $(REGISTRY)/$(DOCKER_REPOSITORY):ffmpeg-hardware \
	--push

	docker build --builder=builder \
	-f docker/ffmpeg-v7-hardware.Dockerfile . \
	--platform=linux/amd64 \
	-t $(REGISTRY)/$(DOCKER_REPOSITORY):ffmpeg-v7-hardware-$(VERSION) \
	-t $(REGISTRY)/$(DOCKER_REPOSITORY):ffmpeg-v7-hardware \
	--push

	docker buildx rm builder
