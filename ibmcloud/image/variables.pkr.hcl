//  variables.pkr.hcl

// For those variables that you don't provide a default for, you must
// set them from the command line, a var-file, or the environment.
variable "ibm_api_key" {
  type = string
}
variable "region" {
  type = string
  default = "jp-tok"
}
variable "subnet_id" {
  type = string
  default = "02f7-0ea72da1-1447-441f-8571-97ba24921378"
}
variable "resource_group_id" {
  type = string
  default = "1b8f7792222a496fadd3de0f2d691860"
}
variable "image_name" {
  type = string
  default = "packer-ibm-podvm-s390x"
}
variable "base_image" {
  type = string
  default = "ibm-ubuntu-20-04-2-minimal-s390x-1"
}
variable "instance_profile" {
  type = string
  default = "bz2-1x4"
}
