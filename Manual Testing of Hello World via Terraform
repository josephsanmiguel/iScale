This is a Step by Step guide to Create EC2 Instance in Terraform Manually:

Step1: Login to EC2 machine via SSH
      cd <path>
      ssh -i <keypairname>.pem ec2-user@<IPv4 Public IP>

    Note: make sure to give permission to the Keypair:
          chmod 0400 <keypairname>.pem

Step 2: Get the link address from the version of your machine and type:(Linux 32 bit in my case)
     
        wget https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_386.zip

        List to check if the file is in the same folder and type:
        ls

Step 3: unzip the file:
        unzip terraform_0.14.7_linux_386.zip

        Do ls to check if there's a binary file(in green):
        ls

        Get the path:
        pwd

        In my case it's /home/ec2-user

Step 4: Add the current directory to the Path:
        echo $"export PATH=\$PATH:$(pwd)" >> ~/.bash_profile
        To get this working run this:
        source ~/.bash_profile
        Check if Terraform is installed type:
        terraform

Step 5: Make a Directory for Terraform:
        mkdir terraform-lab/
        Go to the folder:
        cd terraform-lab/
        Check the folder:
        ls

Step 6: Create a terraform File:
        vim ec2.tf
        
        Insert this in ec2.tf:
        provider "aws" {
          access_key = "<access_key>"
          secret_key = "<secret_key>"
          region     = "<region>"
        }

        resource "aws_instance" "example" {
          ami           = "<ami image>"
          instance_type = "t2.micro"

        Note: Make sure that you have the access_key and scret key from the User.
              Get the AMI from the Instance and Make sure to place the correct region.

Step 7: Initialize Terraform:
        terraform init
        Apply Terraform:
        terraform apply
        yes

      Note: Make Sure to create a group(Name it Ec2 Access Only)
            Then add the user to the group

Optional Step if you want to Destroy the Terraform Type:
        terraform destroy
        yes
