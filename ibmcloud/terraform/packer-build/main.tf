
locals {
  image_map = {
    amd64 = "ibm-ubuntu-20-04-3-minimal-amd64-1"
    s390x = "ibm-ubuntu-20-04-2-minimal-s390x-1"
  }
  profile_map = {
    amd64 = "bx2-1x4"
    s390x = "bz2-1x4"
  }
}

resource "ibm_is_ssh_key" "created_ssh_key" {
  # Create the ssh key only if the public key is set
  count      = var.ssh_pub_key == "" ? 0 : 1
  name       = var.ssh_key_name
  public_key = var.ssh_pub_key
}

data "ibm_is_ssh_key" "ssh_key" {
  # Wait if the key needs creating first
  depends_on = [ibm_is_ssh_key.created_ssh_key]
  name       = var.ssh_key_name
}

resource "ibm_is_vpc" "vpc" {
  name = var.vpc_name
}

resource "ibm_is_public_gateway" "gateway" {
  name = "${var.vpc_name}-gateway"
  vpc  = ibm_is_vpc.vpc.id
  zone = var.zone
}

resource "ibm_is_security_group" "primary" {
  name = "${var.vpc_name}-security"
  vpc  = ibm_is_vpc.vpc.id
}

resource "ibm_is_security_group_rule" "ssh" {
  group = ibm_is_security_group.primary.id
  direction  = "inbound"
  remote     = "0.0.0.0/0"

  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "outbound" {
  group      = ibm_is_security_group.primary.id
  direction  = "outbound"
  remote     = "0.0.0.0/0"
}

resource "ibm_is_subnet" "primary" {
  name                     = "${var.vpc_name}-subnet"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = var.zone
  total_ipv4_address_count = 256
  public_gateway           = ibm_is_public_gateway.gateway.id
}

data "ibm_is_image" "image" {
  name = local.image_map[var.arch]
}

data "ibm_resource_group" "default" {
  is_default = "true"
}

resource "ibm_is_instance" "packer" {
  name    = "${var.vpc_name}-instance"
  image   = data.ibm_is_image.image.id
  profile = local.profile_map[var.arch]

  primary_network_interface {
    subnet = ibm_is_subnet.primary.id
    security_groups = [ibm_is_security_group.primary.id]
  }

  vpc  = ibm_is_vpc.vpc.id
  zone = var.zone
  keys = [data.ibm_is_ssh_key.ssh_key.id]

}

resource "ibm_is_floating_ip" "packer" {
  name = "${var.vpc_name}-floating-ip"
  target = ibm_is_instance.packer.primary_network_interface[0].id
}


resource "local_file" "inventory" {
  filename = "${path.module}/ansible/inventory"
  content = <<EOF
[cluster]
${ibm_is_floating_ip.packer.address}

[cluster:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
EOF
}

resource "local_file" "group_vars" {
  filename = "${path.module}/ansible/group_vars/all"
  content = <<EOF
---
cloud_api_adaptor_repo: ${var.cloud_api_adaptor_repo}
cloud_api_adaptor_branch: ${var.cloud_api_adaptor_branch}
kata_containers_repo: ${var.kata_containers_repo}
kata_containers_branch: ${var.kata_containers_branch}
region: ${var.region}
subnet_id: ${ibm_is_subnet.primary.id}
resource_group_id: ${data.ibm_resource_group.default.id}
ibmcloud_api_key: ${var.ibmcloud_api_key}
instance_profile: ${local.profile_map[var.arch]}
base_image: ${local.image_map[var.arch]}
EOF
}

resource "null_resource" "build_image" {
  triggers = {
    inventory = resource.local_file.inventory.content
    group_vars = resource.local_file.group_vars.content
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/ansible"
    command = "ansible-playbook -i inventory -u root ./build_image.yml"
  }
}
