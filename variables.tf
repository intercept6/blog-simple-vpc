variable "project" {}
variable "env" {}

variable "region" {
  default = "ap-northeast-1"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "num_subnets" {
  default = "3"
}

locals {
  base_name = "${var.project}-${var.env}"

  base_tag = {
    Project     = "${var.project}"
    Environment = "${var.env}"
    Terraform   = "true"
  }
}
