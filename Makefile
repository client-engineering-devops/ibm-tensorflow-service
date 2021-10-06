all: build publish-service

# Please edit these appropriately (as described above)
YOUR_SERVICE_NAME:=tensorflow-server
YOUR_SERVICE_VERSION:=1.0.3
QUAY_REGISTRY:=quay.io/ibmtechgarage

# The "helper" utility is useful for things like this so I included it.
ARCH:=`../helper -a`

build:
	docker build -t $(QUAY_REGISTRY)/$(YOUR_SERVICE_NAME):$(YOUR_SERVICE_VERSION) .

dev:
	docker run -it $(QUAY_REGISTRY)/$(YOUR_SERVICE_NAME):$(YOUR_SERVICE_VERSION) /bin/sh

push:
	docker push $(QUAY_REGISTRY)/$(YOUR_SERVICE_NAME):$(YOUR_SERVICE_VERSION)

publish-service:
	@ARCH=$(ARCH) \
    SERVICE_NAME="$(YOUR_SERVICE_NAME)" \
    SERVICE_VERSION="$(YOUR_SERVICE_VERSION)" \
	REGISTRY_SERVER="$(QUAY_REGISTRY)" \
	hzn exchange service publish -O -f service.json