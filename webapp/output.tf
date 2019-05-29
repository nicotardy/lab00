output "data_vpc_cidr" {
  value = "${data.terraform_remote_state.rs-vpc.vpc_cidr}"
}

output "data_vpc_id" {
  value = "${data.terraform_remote_state.rs-vpc.vpc_id}"
}
