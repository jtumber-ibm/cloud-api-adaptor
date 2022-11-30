locals {
  binary = {
    amd64 = "qemu-system-x86_64"
    s390x = "qemu-system-s390x"
  }
  machine = {
    amd64 = "pc"
    s390x = "s390-ccw-virtio"
  }
}

source "qemu" "ubuntu" {
  boot_command      = ["<enter>"]
  disk_compression  = true
  disk_image        = true
  disk_size         = "${var.disk_size}"
  format            = "qcow2"
  headless          = true
  iso_checksum      = "${var.cloud_image_checksum}"
  iso_url           = "${var.cloud_image_url}"
  output_directory  = "output"
  qemuargs          = [["-m", "${var.memory}"], ["-smp", "cpus=${var.cpus}"], ["-cdrom", "${var.cloud_init_image}"], ["-serial", "mon:stdio"]]
  ssh_password      = "${var.ssh_password}"
  ssh_port          = 22
  ssh_username      = "${var.ssh_username}"
  ssh_wait_timeout  = "300s"
  boot_wait         = "300s"
  vm_name           = "${var.image_name_prefix}-${var.arch}.qcow2"
  shutdown_command  = "sudo shutdown -h now" 
  qemu_binary       = "${lookup(local.binary, var.arch, "qemu-system-x86_64")}" 
  machine_type      = "${lookup(local.machine, var.arch, "pc")}" 
}

build {
  sources = ["source.qemu.ubuntu"]

  provisioner "file" {
    source      = "copy-files.sh"
    destination = "~/copy-files.sh"
  }
}
