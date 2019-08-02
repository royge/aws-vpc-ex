variable "region" {
  description = "AWS region"
}

variable "namespace" {
  description = "Environment or namespace"
}

variable "cidr_blocks" {
  type = "list"
  description = "List of CIDR blocks"
}

variable "ssh_cidr_blocks" {
  type = "list"
  description = "List of CIDR blocks for SSH access"
}
