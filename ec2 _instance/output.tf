output "instance_ip_address" {
  value = aws_instance.demo-server.public_ip
}