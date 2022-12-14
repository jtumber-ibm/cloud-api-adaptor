//  variables.pkr.hcl

// For those variables that you don't provide a default for, you must
// set them from the command line, a var-file, or the environment.


variable "ibm_api_key" {
  type = string
}
variable "region" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "resource_group_id" {
  type = string
}
variable "image_name" {
  type = string
  default = "podvm-packer-image"
}
// amd64 = "ibm-ubuntu-20-04-3-minimal-amd64-1"
// s390x  = "ibm-ubuntu-20-04-2-minimal-s390x-1"
variable "base_image" {
  type = string
  default = "ibm-ubuntu-18-04-1-minimal-s390x-3"
}
// amd64 = "bx2-2x8"
// s390x  = "bz2-2x8"
variable "instance_profile" {
  type = string
  default = "bz2-2x8"
}
