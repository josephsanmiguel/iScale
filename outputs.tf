output "elastic_ip" {
  value       = aws_eip.one.public_ip
  description = "The Elastic IP of the web server"
}
