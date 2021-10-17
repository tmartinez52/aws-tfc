provider "aws" {
  region = var.region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_tag
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.my_subnet
  availability_zone = var.availability_zone

  tags = {
    Name = "tfc-example"
  }
}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = [var.network_interface_ip]

  tags = {
    Name = "primary_network_interface"
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ubuntu" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  
  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }
  
  tags = {
    Name                 = var.instance_name
    "Linux Distribution" = "Ubuntu"
  }
}

