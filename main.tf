provider "aws" {
    region = var.region
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    
    tags = {
        Name = var.tag
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = var.tag
    }
}

resource "aws_route_table" "prod-route-table" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    tags = {
        Name = var.tag
    }
}

resource "aws_subnet" "subnet-one" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
        Name = var.tag
    }
}

resource "aws_route_table_association" "a" {
    subnet_id = aws_subnet.subnet-one.id
    route_table_id = aws_route_table.prod-route-table.id
}

resource "aws_security_group" "allow_web" {
    name = "allow_web"
    description = "Allow Web inbound traffic"
    vpc_id  = aws_vpc.main.id

    ingress {
        description = "HTTPS"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "Allow Web"
    }
}

resource "aws_network_interface" "web-server-nic" {
    subnet_id = aws_subnet.subnet-one.id 
    private_ips = ["10.0.1.50"]
    security_groups = [aws_security_group.allow_web.id] 
}

resource "aws_eip" "one" {
    vpc = true
    network_interface = aws_network_interface.web-server-nic.id
    associate_with_private_ip = "10.0.1.50"

    depends_on = [aws_internet_gateway.gw]
}

resource "aws_instance" "web-server-instance" {
    ami =  "ami-09e67e426f25ce0d7"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "main-key"

    network_interface {
        device_index = 0 
        network_interface_id = aws_network_interface.web-server-nic.id
    }

    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c "echo your very first web server  > /var/www/html/index.html"
                EOF
    tags = {
        Name = var.tag
    }
}
