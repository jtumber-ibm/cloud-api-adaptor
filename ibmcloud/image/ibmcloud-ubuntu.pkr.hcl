packer {
  required_plugins {
    ibmcloud = {
      version = ">=v3.0.0"
      source  = "github.com/IBM/ibmcloud"
    }
  }
}

source "ibmcloud-vpc" "ubuntu" {
  api_key = "${var.ibm_api_key}"
  region  = "${var.region}"

  subnet_id         = "${var.subnet_id}"
  resource_group_id = "${var.resource_group_id}"

  vsi_base_image_name = "${var.base_image}"
  vsi_profile         = "${var.instance_profile}"
  vsi_interface       = "public"
  image_name          = "${var.image_name}"

  communicator = "ssh"
  ssh_username = "root"
  ssh_port     = 22
  ssh_timeout  = "5m"

  timeout = "10m"
}

build {
  name = "peer-pod-ubuntu"
  sources = [
    "source.ibmcloud-vpc.ubuntu"
  ]

    provisioner "shell-local" {
    command = "tar cf toupload/files.tar -C ../../podvm files"
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
