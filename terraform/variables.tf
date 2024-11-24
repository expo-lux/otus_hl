variable "token" {
  type = string
}

variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "ssh_key_private" {
  type = string
  default = "./id_rsa_yc"
  description = "path to private key"
}

variable "image_id" {
  type    = string
  default = "fd80ok8sil1fn2gqbm6h" # Ubuntu 2204
  description = "image ID of boot disk"
}

variable "default_zone" {
  type    = string
  default = "ru-central1-d"
  description = "default zone for VPC and VM"
}

variable "default_cidr" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "name_prefix" {
  type    = string
  default = "otus-hl"
  description = "prefix for VPC, VM, boot disk, subnet name"
}
