# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This script was create by Joseph Angelo T. San Miguel 
# Please feel free to add or comment on how can I improve more.
# Provision a new application server and deploy the following application
# This template runs a simple "Hello, World" web server on a single EC2 Instance
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ----------------------------------------------------------------------------------------------------------------------
# Come up with a way to deploy this app and write configuration-as-code to deploy it.
# We are primarily using Terraform/Salt but feel free to use any Configuration Management tool (Chef, Puppet, Ansible, Salt) and/or Infrastructure-as-code (Terraform, Cloudformation, Pulumi) as you so choose.
# ###### I chose Terraform and ran it on VSCODE #######
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------
terraform {
  # It only accepts Terraform version 0.12.26 or Higher
  required_version = ">= 0.12.26"
}
# ------------------------------------------------------------------------------
# Main requirement is to deploy this to AWS. You can create a free-tier AWS account.
# Connection to AWS
# Please take note to change the value of the variables in variables.tf
# (As a security measure, I did not hardcode the access key and secret key)
# ------------------------------------------------------------------------------
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
# Create a VPC
resource "aws_vpc" "vpc-dev" {
  cidr_block  = "10.0.0.0/16"
    tags = {
    Name = "development"
    }
}
# create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc-dev.id
}
# create custom route table
resource "aws_route_table" "dev-route-table" {
  vpc_id = aws_vpc.vpc-dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "Dev"
  }
}
# create a subnet
resource "aws_subnet" "subnet-1" {
      vpc_id = aws_vpc.vpc-dev.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
    tags = {
        Name = "dev-subnet"
  }
}
# associate subnet with route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.dev-route-table.id
}
# ---------------------------------------------------------------------------------------------------------------------
# Ensure that the instance is locked down and secure
# Create the Security Group and apply to the EC2 Instance Created above
# You can change the Inbound rules accordingly depending on the requirements of your project
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.vpc-dev.id
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_web"
  }
}
# create a network interface with an ip in the subnet that as created
resource "aws_network_interface" "web-server-nic" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}
# assign an elastic IP to the network interface created in step 7
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.gw, aws_instance.web-server-instance] 
}
# ---------------------------------------------------------------------------------------------------------------------
# Create an EC2 Instance
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_instance" "web-server-instance" {
  ami                    = "ami-047a51fa27710816e"
  instance_type          = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "main-key"
 
    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.web-server-nic.id
    }

  user_data = <<-EOF
              #!/bin/bash
              sudo su
              yum update -y
              yum install -y httpd.x86_64
              systemctl start httpd.service
              systemctl enable httpd.service
              bash -c 'echo Hello World > /var/www/html/index.html'
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  tags = {
    Name = "web-server"
  }
}
