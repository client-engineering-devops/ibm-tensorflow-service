all: build publish-service

# Please edit these appropriately (as described above)
YOUR_SERVICE_NAME:=tensorflow-server
YOUR_SERVICE_VERSION:=1.0.3
QUAY_REGISTRY:=quay.io/ibmtechgarage

# Define the shared volumes for parent
MMS_HELPER_SHARED_VOLUME:=tensorflow_volume
MMS_HELPER_SHARED_DIR:=/models

# The "helper" utility is useful for things like this so I included it.
ARCH:=`./horizon/scripts/helper -a`

YOUR_SERVICE_CONTAINER:=$(QUAY_REGISTRY)/$(YOUR_SERVICE_NAME)_$(ARCH):$(YOUR_SERVICE_VERSION)

build:
	docker build -t $(QUAY_REGISTRY)/$(YOUR_SERVICE_NAME):$(YOUR_SERVICE_VERSION) .

dev:
	docker run -it -v `pwd`:/outside -v $(MMS_HELPER_SHARED_VOLUME):$(MMS_HELPER_SHARED_VOLUME):rw $(YOUR_SERVICE_CONTAINER) bin/bash
	
push:
	docker push $(QUAY_REGISTRY)/$(YOUR_SERVICE_NAME):$(YOUR_SERVICE_VERSION)

publish-service:
	@ARCH=$(ARCH) \
    SERVICE_NAME="$(YOUR_SERVICE_NAME)" \
    SERVICE_VERSION="$(YOUR_SERVICE_VERSION)" \
	REGISTRY_SERVER="$(QUAY_REGISTRY)" \
	SHARED_VOLUME="$(MMS_HELPER_SHARED_VOLUME)" \
	hzn exchange service publish -O -f horizon/service.json

clean:
	hzn exchange service remove -f "${HZN_ORG_ID}/$(YOUR_SERVICE_NAME)_$(YOUR_SERVICE_VERSION)_$(ARCH)"
	docker rmi -f "$(YOUR_SERVICE_CONTAINER)"