// variables.pkr.hcl

// For those variables that you don't provide a default for, you must
// set them from the command line, a var-file, or the environment.

variable "cloud_init_image" {
  type    = string
  default = "cloud-init.img"
}

variable "cpus" {
  type    = string
  default = "2"
}

variable "disk_size" {
  type    = string
  default = "6144"
}

variable "cloud_image_checksum" {
  type    = string
  default = "b89072c376f980beb080e2bf9d8b71fe865e264c8387bfc6d11cb06b5f276804"
}

variable "cloud_image_url" {
  type    = string
  default = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-s390x.img"
}

variable "arch" {
  type = string
  default = "s390x"
}

variable "memory" {
  type    = string
  default = "2048M"
}

variable "ssh_password" {
  type    = string
  default = "PeerP0d"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "image_name_prefix" {
  type    = string
  default = "podvm-image"
}
