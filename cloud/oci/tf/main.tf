terraform {
  backend "s3" {
    bucket                      = "tfstate"
    key                         = "oci/terraform.tfstate"
    region                      = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
    use_lockfile                = true
  }
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

provider "oci" {
  region = "us-chicago-1"
}

resource "oci_identity_compartment" "dispatch_compartment" {
  compartment_id = var.tenancy_ocid
  name           = "dispatch-tf"
  description    = "compartment created by terraform"
  enable_delete  = false // true will cause this compartment to be deleted when running `terrafrom destroy`
}

resource "oci_core_vcn" "dispatch_vcn" {
  compartment_id = oci_identity_compartment.dispatch_compartment.id
  display_name   = "dispatchvcn"
  dns_label      = "vcn0"
  cidr_blocks    = ["10.3.0.0/24"]
  is_ipv6enabled = true
}

resource "oci_core_internet_gateway" "dispatch_internet_gateway" {
  compartment_id = oci_identity_compartment.dispatch_compartment.id
  vcn_id         = oci_core_vcn.dispatch_vcn.id
}

resource "oci_core_default_route_table" "dispatch_default_route_table" {
  manage_default_resource_id = oci_core_vcn.dispatch_vcn.default_route_table_id

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.dispatch_internet_gateway.id
  }
  route_rules {
    destination       = "::/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.dispatch_internet_gateway.id
  }
}

resource "oci_core_subnet" "dispatch_subnet" {
  compartment_id  = oci_identity_compartment.dispatch_compartment.id
  vcn_id          = oci_core_vcn.dispatch_vcn.id
  display_name    = "dispatchsubnet"
  dns_label       = "sub0"
  ipv4cidr_blocks = ["10.3.0.0/26"]
  ipv6cidr_blocks = [cidrsubnet(oci_core_vcn.dispatch_vcn.ipv6cidr_blocks[0], 8, 0)]
}

resource "oci_core_instance" "dispatch_instance" {
  availability_domain = "RVCJ:US-CHICAGO-1-AD-1"
  compartment_id      = oci_identity_compartment.dispatch_compartment.id
  shape               = "VM.Standard.A1.Flex"
  display_name        = "dispatch-instance"
  shape_config {
    ocpus         = 4
    memory_in_gbs = 24
  }
  create_vnic_details {
    subnet_id                 = oci_core_subnet.dispatch_subnet.id
    assign_public_ip          = true
    assign_private_dns_record = true
    assign_ipv6ip             = true
    hostname_label            = "dispatch"
  }
  source_details {
    source_type = "image"
    # https://docs.oracle.com/en-us/iaas/images/oracle-linux-10x/oracle-linux-10-1-aarch64-2026-02-28-0.htm
    source_id               = "ocid1.image.oc1.us-chicago-1.aaaaaaaa2sbfjysvk662h4z7envl3yjczltvjcobx6f7th27h6gke3zaqiea" //Oracle-Linux-10.1-aarch64-2026.02.28-0
    boot_volume_size_in_gbs = 50
  }
  metadata = {
    user_data = "${base64encode(file("${path.module}/cloud-config.yaml"))}"
  }
}

output "instance" {
  value = oci_core_instance.dispatch_instance.public_ip
}
