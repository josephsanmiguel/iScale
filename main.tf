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

provider "aws" {
  region = "ap-southeast-2"
  access_key = var.aws_access_key_id_var
  secret_key = var.aws_secret_access_key_id_var
}

# ---------------------------------------------------------------------------------------------------------------------
# Create an EC2 Instance
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "example" {
  ami                    = "ami-04f77aa5970939148"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

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
    Name = "terraform-example"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# Ensure that the instance is locked down and secure
# Create the Security Group and apply to the EC2 Instance Created above
# You can change the Inbound rules accordingly depending on the requirements of your project
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

    # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTP from anywhere
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

}
