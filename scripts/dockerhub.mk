DOCKER_REPOSITORY = thomisus/mediamtx

dockerhub:
	$(eval VERSION := $(shell git describe --tags | tr -d v))

	docker login -u $(DOCKER_USER) -p $(DOCKER_PASSWORD)

	docker buildx rm builder 2>/dev/null || true
	docker buildx create --name=builder

	docker build --builder=builder \
	-f docker/ffmpeg-rpi.Dockerfile . \
	--platform=linux/arm/v6,linux/arm/v7,linux/arm64 \
	-t $(DOCKER_REPOSITORY):ffmpeg-rpi-$(VERSION) \
	-t $(DOCKER_REPOSITORY):ffmpeg-rpi \
	--push

	docker build --builder=builder \
	-f docker/rpi.Dockerfile . \
	--platform=linux/arm/v6,linux/arm/v7,linux/arm64 \
	-t $(DOCKER_REPOSITORY):rpi-$(VERSION) \
	-t $(DOCKER_REPOSITORY):rpi \
	--push

	docker build --builder=builder \
	-f docker/ffmpeg.Dockerfile . \
	--platform=linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64 \
	-t $(DOCKER_REPOSITORY):ffmpeg-$(VERSION) \
	-t $(DOCKER_REPOSITORY):ffmpeg \
	--push

	docker build --builder=builder \
	-f docker/standard.Dockerfile . \
	--platform=linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64 \
	-t $(DOCKER_REPOSITORY):$(VERSION) \
	-t $(DOCKER_REPOSITORY):latest \
	--push

	docker build --builder=builder \
	-f docker/ffmpeg-hardware.Dockerfile . \
	--platform=linux/amd64 \
	-t $(DOCKER_REPOSITORY):ffmpeg-hardware-$(VERSION) \
	-t $(DOCKER_REPOSITORY):ffmpeg-hardware \
	--push

	docker buildx rm builder
