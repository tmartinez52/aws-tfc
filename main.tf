provider "aws" {
  region = var.region
}

resource "aws_cloud9_environment_ec2" "cloud9_tfc" {
  name = var.instance_name
  instance_type = var.instance_type
  subnet_id = aws_subnet.my_subnet.id
  depends_on = [aws_subnet.my_subnet]
}

data "aws_instance" "cloud9_instance" {
  filter {
    name = "tag:aws:cloud9:environment"
    values = [
      aws_cloud9_environment_ec2.cloud9_tfc.id]
  }
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
  
  map_public_ip_on_launch = true
  
  
  tags = {
    Name = "tfc-example"
  }
}

output "cloud9_url" {
  value = "https://${var.region}.console.aws.amazon.com/cloud9/ide/${aws_cloud9_environment_ec2.cloud9_tfc.id}"
}
