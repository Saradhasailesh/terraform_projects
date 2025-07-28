
resource "aws_security_group" "web_server_sg" {
  name        = "web-server-sg"
  description = "Allow all HTTP connection requests"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0

  }

}

# Declare the data source
data "aws_availability_zones" "available" {
}

resource "aws_key_pair" "web-server-key" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_instance" "web_server_ec2" {
  ami               = var.ami
  instance_type     = var.instance_type
  key_name          = var.key_name
  availability_zone = data.aws_availability_zones.available.names[0]
  security_groups   = ["${aws_security_group.web_server_sg.name}"]
  user_data         = <<-EOF
  #!/bin/bash
   apt-get update -y
   apt-get install -y apache2
   systemctl start apache2
   systemctl enable apache2
   echo "<html><h1> Welcome to my WebServer. Happy learning...</h1></html>" >> /var/www/html/index.html
   EOF
  tags = {
    Name = "web_server"
  }

}

