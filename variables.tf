variable "region" {
  description = "AWS region"
  default     = "us-west-1"
}

variable "cidr_block" {
  description = "CIDR Block"
  default     = "10.0.0.0/16"
}

variable "my_subnet" {
  description = "Subnet"
  default     = "10.0.0.0/24"
}

variable "network_interface_ip" {
  description = "Network interface"
  default     = "10.0.0.10"
}

variable "vpc_tag" {
  description = "Tag for VPC"  
  default     = "vpc-tag"
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

variable "environment_tag" {
  description = "Tag"
  default     = "DEV"
}
variable "public_key_path" {
  description = "CIDR block range"
  default     = "./"
}
