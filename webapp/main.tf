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
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

resource "aws_key_pair" "web_instance_key_pair" {
  key_name   = "web-instance-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDWjBiDOTW+jMD5vaudA9clsf0x0RUgjiWaPKaXMiuWxqSqb6HhSevFedOQAfed0eiIp69+gkJpcp3XYtXGWAfTKmozTqL0JyGOLI+LrDf2HCm1ybeOxJkP2XudAmfbNJpdJnMAEeoSSZBsgGXD/ap9Fu6w3Xo+6tHy766ZBRizlGnlaSFi34S4pnj4ZNkLgmNZurUBiqDNvFbcQ8rrUkalQkT4p+lAROjzx8cctcj6GXmFa2y0lJ0H7/2F/nswfzY6mcpcRLZcQp8V0Pz7MGQokkTO7u3ERFUPdEZK/DMVb1D76Q6em4rxudUJKTiMf5IJfw3rO91SULvIyeVY4uMF"
}

resource "aws_instance" "web" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  key_name               = "${aws_key_pair.web_instance_key_pair.key_name}"
  vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
  user_data              = "${data.template_file.usr_data.rendered}"
  subnet_id              = "${data.terraform_remote_state.rs-vpc.subnet_id[0]}"
  # attention par defaut les instance ec2 ne generent pas de public ip
  associate_public_ip_address = "true"

  tags {
    Name = "HelloWorld"
  }
}

# yannick lorenzati 
# julien simon 
# thomas boutri

