output "security_group_ids" {
  value = [aws_security_group.ec2_s3_sg.id]
}

output "subnet_id" {
  value = aws_subnet.ec2_s3_pub_sn.id
}

