provider "aws" {
  region = "eu-west-1"
}

data "terraform_remote_state" "rs-vpc" {
  backend = "s3"

  config = {
    region = "eu-west-1"
    bucket = "lab-nta-tfstate-bucket"
    key    = "vpc/terraform.tfstate"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${data.terraform_remote_state.rs-vpc.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "usr_data" {
  template = "${file("${path.module}/userdata.tpl")}"

  vars {
    username = "${var.username}"
  }
}

# yannick lorenzati 
# julien simon 
# thomas boutri

