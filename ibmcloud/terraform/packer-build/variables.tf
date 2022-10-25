
variable "ibmcloud_api_key" {
 sensitive = true 
}

variable "vpc_name" {
    default = "packer-build"
}
variable "zone" {
    default = "jp-tok-1"
}
variable "region" {
    default = "jp-tok"
}
variable "arch" {
    default = "amd64"
}
variable "ssh_pub_key" {
    default = ""
}
variable "ssh_key_name" {

}
