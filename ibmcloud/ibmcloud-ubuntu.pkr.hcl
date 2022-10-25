packer {
  required_plugins {
    ibmcloud = {
      version = ">=v3.0.0"
      source  = "github.com/IBM/ibmcloud"
    }
  }
}

local {
  base_image_map = {
    amd64 = "ibm-ubuntu-20-04-3-minimal-amd64-1"
    s390x  = "ibm-ubuntu-18-04-1-minimal-s390x-3"
  }
  instance_profile_map = {
    amd64 = "bx2-2x8"
    s390x  = "bz2-2x8"
  }
}

source "ibmcloud-vpc" "ubuntu" {
  api_key = "${var.ibm_api_key}"
  region  = "${var.region}"

  subnet_id         = "${var.subnet_id}"
  resource_group_id = "${var.resource_group_id}"

  vsi_base_image_name = "${local.base_image_map[${var.arch}]}"
  vsi_profile         = "${local.instance_profile_map[${var.arch}]}"
  vsi_interface       = "public"
  image_name          = "${var.image_name}"

  communicator = "ssh"
  ssh_username = "root"
  ssh_port     = 22
  ssh_timeout  = "15m"

  timeout = "30m"
}

build {
  name = "peer-pod-ubuntu"
  sources = [
    "source.ibmcloud-vpc.ubuntu"
  ]

  provisioner "shell-local" {
    command = "tar cf toupload/files.tar files"
  }

  provisioner "file" {
    source      = "./toupload"
    destination = "/tmp/"
  }

  provisioner "shell" {
    inline = [
      "cd /tmp && tar xf toupload/files.tar",
      "rm toupload/files.tar"
    ]
  }

  provisioner "file" {
    source      = "copy-files.sh"
    destination = "~/copy-files.sh"
  }

  provisioner "shell" {
    remote_folder = "~"
    inline = [
      "sudo bash ~/copy-files.sh"
    ]
  }

}
