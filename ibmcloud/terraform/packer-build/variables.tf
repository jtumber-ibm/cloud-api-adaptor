
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

variable "cloud_api_adaptor_branch" {
    default = "ibmcloud_packer"
}

variable "cloud_api_adaptor_url" {
    default = "https://github.com/jtumber-ibm/cloud-api-adaptor.git"
}   

variable "kata_containers_repo" {
    description = "Repository URL of Kata Containers"
    default = "https://github.com/kata-containers/kata-containers.git"
}

variable "kata_containers_branch" {
    description = "Branch name of Kata Containers"
    default = "CCv0"
}
