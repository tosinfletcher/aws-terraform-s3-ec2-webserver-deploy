variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "cidr_public_subnet" {
  type    = string
  default = "10.0.1.0/24"
}

variable "cidr_private_subnet" {
  type    = string
  default = "10.0.2.0/24"
}

