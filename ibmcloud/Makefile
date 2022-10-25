.PHONY: build clean

include ../image/Makefile

build: $(IMAGE_FILE)

$(IMAGE_FILE): $(BINARIES) $(FILES)
	mkdir -p toupload
	packer build -var ibm_api_key=${IBM_API_KEY} \
		-var region=${REGION} \
		-var subnet_id=${SUBNET_ID} \
		-var resource_group_id=${RESOURCE_GROUP_ID} \
		-var arch=${ARCH} \
		-var image_name=${IMAGE_NAME} .
	rm -fr toupload
