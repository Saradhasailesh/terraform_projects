
resource "aws_key_pair" "web-server-key" {
  key_name   = var.key_name
  public_key = var.public_key
}

data "aws_availability_zones" "available" {
  
}

resource "aws_instance" "my_ec2_s3_instance" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = var.key_name
    availability_zone = data.aws_availability_zones.available.names[0]
    vpc_security_group_ids = var.security_group_ids
    subnet_id = var.subnet_id
    associate_public_ip_address = true
    iam_instance_profile = "EC2_S3_Role"
    user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install httpd -y 
    aws s3 cp s3://${var.bucket_name_final}/index.html /var/www/html/index.html
    systemctl start httpd
    systemctl enable httpd
    EOF
    tags= {
        Name = "my-ec2-s3-instance"
    }    
}