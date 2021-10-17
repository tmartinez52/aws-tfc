variable "region" {
  description = "AWS region"
  default     = "us-west-1"
}

variable "availability_zone" {
  description = "AWS AZ"
  default     = "us-west-1a"
}

variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t2.micro"
}

variable "instance_name" {
  description = "EC2 instance name"
  default     = "Provisioned by Terraform"
}
