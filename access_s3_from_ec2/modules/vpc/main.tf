
resource "aws_vpc" "ec2_s3_vpc"{
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "ec2-s3-vpc"
    }

}

resource "aws_security_group" "ec2_s3_sg"{

    name = "ec2_s3_sg"
    description = "Allow all http and https"
    vpc_id = aws_vpc.ec2_s3_vpc.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }

}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "ec2_s3_pub_sn" {
    vpc_id = aws_vpc.ec2_s3_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = data.aws_availability_zones.available.names[0]
    tags = {
      Name = "ec2-s3-pub-sn"
    }
  
}
resource "aws_internet_gateway" "ec2_s3_igw" {
vpc_id = aws_vpc.ec2_s3_vpc.id

tags = {
  Name = "ec2-s3-igw"
}
  
}

resource "aws_route_table" "ec2_s3_rt" {
  vpc_id = aws_vpc.ec2_s3_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ec2_s3_igw.id
  }
  tags = {
    Name = "ec2-s3-rt"
  }

}

resource "aws_route_table_association" "ec2_s3_rt_assotn" {
   subnet_id =  aws_subnet.ec2_s3_pub_sn.id
   route_table_id = aws_route_table.ec2_s3_rt.id  
}




