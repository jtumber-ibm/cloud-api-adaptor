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
  vm_name           = "${var.qemu_image_name}"
  shutdown_command  = "sudo shutdown -h now" 
  qemu_binary       = "qemu-system-s390x"
  machine_type      = "s390-ccw-virtio"
}

build {
  sources = ["source.qemu.ubuntu"]
}
