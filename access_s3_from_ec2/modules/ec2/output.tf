output "public_ip" {
    value = aws_instance.my_ec2_s3_instance.public_ip
  
}

output "instance_state" {
  value = aws_instance.my_ec2_s3_instance.instance_state
}