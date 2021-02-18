
provider "aws" {
  access_key = "AKIATTJRJLSTYJNANVSW"
  secret_key = "uxJPWUgjlQT5hxJCorwR9cuCu8MQUJsllzohEBE7"
  region     = "ap-southeast-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0e2e44c03b85f58b3"
  instance_type = "t2.micro"
