variable "region" {}

variable "compartment_ocid" {
}

variable "tenancy_ocid" {
}

variable "user_ocid" {
}

variable "private_key_path" {
}

variable "fingerprint" {
}

variable "availablity_domain_name" {
  default = ""
}

variable "hostname" {
  default = "srvweb"
}

variable "instance_shape" {
  description = "Instance Shape"
  default     = "VM.Standard.A1.Flex"
}

variable "instance_ocpus" {
  default = 1
}

variable "instance_shape_config_memory_in_gbs" {
  default = 6
}

