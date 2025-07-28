output "instance_ip_address" {
  value = aws_instance.ansible_control_node.public_ip
}