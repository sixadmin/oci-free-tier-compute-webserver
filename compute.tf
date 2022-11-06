resource "oci_core_instance" "compute_instance" {
  availability_domain = var.availablity_domain_name == "" ? data.oci_identity_availability_domains.ads.availability_domains[0]["name"] : var.availablity_domain_name
  compartment_id      = var.compartment_ocid
  display_name        = "${var.hostname}"
  shape               = var.instance_shape
  fault_domain        = "FAULT-DOMAIN-1"

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_shape_config_memory_in_gbs
  }

   metadata = {
        ssh_authorized_keys = file("/home/richard/.ssh/oci.pub")
        user_data = base64encode(file("./cloud-init/vm.cloud-config"))
    } 

  create_vnic_details {
    subnet_id                 = oci_core_subnet.subnet.id
    display_name              = "${var.hostname}"
    assign_public_ip          = true
    assign_private_dns_record = true
  }

  source_details {
    source_type             = "image"
    source_id               = "ocid1.image.oc1.eu-paris-1.aaaaaaaa2kukypyttuyb6vkpjbdrzl5dm2cg7mxniigjdukbfvelwlesrurq"
    boot_volume_size_in_gbs = "50"
  }

  timeouts {
    create = "60m"
  }
}
