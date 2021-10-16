all: build publish-service publish-deployment-policy


#  Regsitry Settings
#
REG_USER:=smcotugno

QUAY_HOST:=quay.io
QUAY_NAMESPACE:=ibmtechgarage
REG_HOST:=$(QUAY_HOST)/$(QUAY_NAMEPSACE)

# Define the shared volumes for parent
MMS_HELPER_SHARED_VOLUME:=tensorflow_volume
MMS_HELPER_SHARED_DIR:=/models

# Please edit these appropriately (as described above)
YOUR_SERVICE_NAME:=tensorflow-server
YOUR_SERVICE_VERSION:=1.0.4

DEPLOYMENT_POLICY:=tensorflow-deploy-policy
DEPLOYMENT_POLICY_FILE=horizon/deploy-policy.json
SERVICE_DEFINITION_FILE:=horizon/service.json
NODE_POLICY_FILE:=horizon/node-policy.json

# Setup variables based on the above
YOUR_SERVICE_IMAGE:="$(REG_HOST)/$(YOUR_SERVICE_NAME)_$(ARCH):$(YOUR_SERVICE_VERSION)"
YOUR_SERVICE_HZN_NAME:="$(YOUR_SERVICE_NAME)_$(YOUR_SERVICE_VERSION)_$(ARCH)"
REG_HOST_USER_TOKEN=${REG_HOST}:${REG_USER}:${REG_TOKEN}


# The "helper" utility is useful for things like this so I included it.
ARCH:=`./horizon/scripts/helper -a`
	
login:
        echo "${REG_TOKEN}" | docker login -u ${REG_USER} --password-stdin ${REG_HOST}

build:
	docker build -t $(YOUR_SERVICE_NAME)_$(ARCH):$(YOUR_SERVICE_VERSION) .

create-volume:
        docker volume create $(MMS_HELPER_SHARED_VOLUME)

delete-volume:
        docker volume rm $(MMS_HELPER_SHARED_VOLUME)

dev:
	docker run -it -v `pwd`:/outside -v $(MMS_HELPER_SHARED_VOLUME):$(MMS_HELPER_SHARED_DIR):rw $(YOUR_SERVICE_IMAGE) bin/bash

push:
        docker tag  $(YOUR_SERVICE_NAME)_$(ARCH):$(YOUR_SERVICE_VERSION) $(YOUR_SERVICE_IMAGE)
        docker push $(YOUR_SERVICE_IMAGE)


publish-service:
        @ARCH=$(ARCH) \
        SERVICE_NAME="$(YOUR_SERVICE_NAME)" \
        SERVICE_VERSION="$(YOUR_SERVICE_VERSION)" \
        SERVICE_IMAGE="$(YOUR_SERVICE_IMAGE)" \
        SHARED_VOLUME="$(MMS_HELPER_SHARED_VOLUME)" \
        hzn exchange service publish -I -O -r '${REG_HOST_USER_TOKEN}' -f ${SERVICE_DEFINITION_FILE}

publish-deployment-policy:
        @ARCH=$(ARCH) \
        SERVICE_NAME="$(YOUR_SERVICE_NAME)" \
        SERVICE_VERSION="$(YOUR_SERVICE_VERSION)"\
        SERVICE_URL="$(YOUR_SERVICE_HZN_NAME)" \
        SERVICE_CONTAINER="$(YOUR_SERVICE_IMAGE)" \
        POLICY_NAME="$(DEPLOYMENT_POLICY)" \
        hzn exchange deployment addpolicy --json-file=$(DEPLOYMENT_POLICY_FILE) --no-constraints "$(DEPLOYMENT_POLICY)"

register-policy:
        hzn register --policy "$(NODE_POLICY)"

clean:
        hzn unregister -f; \
        hzn exchange service removepolicy  -f "${HZN_ORG_ID}/$(YOUR_SERVICE_HZN_NAME)"; \
	hzn exchange service remove -f "${HZN_ORG_ID}/$(YOUR_SERVICE_HZN_NAME)" \
        docker rmi -f  $(YOUR_SERVICE_IMAGE)