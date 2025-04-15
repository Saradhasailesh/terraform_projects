output "web_instance_ip" {
  value = aws_instance.web_server_ec2.public_ip
}