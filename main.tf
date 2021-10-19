provider "aws" {
  region = var.region
}

resource "aws_cloud9_environment_ec2" "cloud9_tfc" {
  instance_type = var.instance_type
}

data "aws_instance" "cloud9_instance" {
  filter {
    name = "tag:aws:cloud9:environment"
    values = [
      aws_cloud9_environment_ec2.cloud9_tfc.id]
  }
}

output "cloud9_url" {
  value = "https://${var.region}.console.aws.amazon.com/cloud9/ide/${aws_cloud9_environment_ec2.cloud9_tfc.id} 
}
