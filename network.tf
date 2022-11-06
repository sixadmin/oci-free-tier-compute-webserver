resource "oci_core_vcn" "vcn" {
  cidr_block = "10.1.0.0/16"
  compartment_id = var.compartment_ocid
  display_name = "vcn-${var.hostname}"
  dns_label = "vcn${var.hostname}"
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name = "ig-${var.hostname}"
  vcn_id = oci_core_vcn.vcn.id
}

resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id
  display_name = "rt-${var.hostname}"

  route_rules {
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}

resource "oci_core_network_security_group" "nsg" {
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn.id
  display_name = "nsg-${var.hostname}"
}

resource "oci_core_network_security_group_security_rule" "nsg_outbound" {
  network_security_group_id = "${oci_core_network_security_group.nsg.id}"
  direction = "EGRESS"
  protocol = "all"
  description = "nsg-${var.hostname}-outbound"
  destination = "0.0.0.0/0"
  destination_type = "CIDR_BLOCK"
}

resource "oci_core_subnet" "subnet" {
  cidr_block        = "10.1.0.0/24"
  display_name      = "subnet-${var.hostname}"
  dns_label = "subnet${var.hostname}"
  compartment_id    = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn.id
  route_table_id = oci_core_vcn.vcn.default_route_table_id
  dhcp_options_id = oci_core_vcn.vcn.default_dhcp_options_id
  security_list_ids = [oci_core_security_list.sl.id]

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

resource "oci_core_security_list" "sl" {
  compartment_id = var.compartment_ocid
  display_name   = "seclist-${var.hostname}"
  vcn_id         = oci_core_vcn.vcn.id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  ingress_security_rules {

    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = 22
      min = 22
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = 80
      min = 80
    }
  }
}


