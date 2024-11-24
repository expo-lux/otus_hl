terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  zone      = var.default_zone
  folder_id = var.folder_id
}

resource "yandex_compute_disk" "boot-disk-1" {
  name     = "${var.name_prefix}-disk-1"
  type     = "network-hdd"
  zone     = var.default_zone
  size     = "20"
  image_id = var.image_id
}

resource "yandex_vpc_network" "network-1" {
  name = "${var.name_prefix}-vpc-1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "${var.name_prefix}-subnet-1"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = var.default_cidr
}

resource "yandex_compute_instance" "vm-1" {
  name        = "${var.name_prefix}-vm-1"
  platform_id = "standard-v2"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-1.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.txt")}"
  }

  connection {
    type        = "ssh"
    user        = "ansible-user"
    private_key = file(var.ssh_key_private)
    host        = self.network_interface[0].nat_ip_address
  }

  provisioner "remote-exec" {
    inline = ["touch /tmp/1"]
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ansible-user -i '${self.network_interface[0].nat_ip_address},' --private-key ${var.ssh_key_private} provision.yml"
  }
}

output "internal_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

output "external_ip_address_vm_1" {
  value = yandex_compute_instance.vm-1.network_interface.0.nat_ip_address
}


# provisioner "local-exec" {
#   command = "ansible-playbook -u dmitry -i '${self.public_ip},' --private-key ${var.ssh_key_private} provision.yml" 
# }