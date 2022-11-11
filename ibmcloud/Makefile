.PHONY: build clean

include ../image/Makefile

build: $(IMAGE_FILE)

UBUNTU_IMAGE_URL  := https://cloud-images.ubuntu.com/$(UBUNTU_RELEASE)/current/$(UBUNTU_RELEASE)-server-cloudimg-$(ARCH).img
UBUNTU_IMAGE_CHECKSUM := $(shell curl -LO  https://cloud-images.ubuntu.com/"$(UBUNTU_RELEASE)"/current/SHA256SUMS && \
				grep "$(UBUNTU_RELEASE)"-server-cloudimg-"$(ARCH)".img SHA256SUMS | awk '{print $$1}' && \
				rm -f SHA256SUMS)
				
$(IMAGE_FILE): $(BINARIES) $(FILES)
	cloud-localds cloud-init.img userdata.cfg
	mkdir -p toupload
	packer build -var qemu_image_name=${IMAGE_FILE} \
		-var cloud_image_url=${UBUNTU_IMAGE_URL} \
		-var cloud_image_checksum=${UBUNTU_IMAGE_CHECKSUM} .
	rm -fr toupload
	rm -f cloud-init.img
