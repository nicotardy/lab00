output "data_vpc_cidr" {
  value = "${data.terraform_remote_state.rs-vpc.vpc_cidr}"
}

output "data_vpc_id" {
  value = "${data.terraform_remote_state.rs-vpc.vpc_id}"
}

/*
output "public_ip" {
  value = "${aws_instance.web.public_ip}"
}
*/

output "dns_name" {
  value = "${aws_elb.web_elb.dns_name}"
}
