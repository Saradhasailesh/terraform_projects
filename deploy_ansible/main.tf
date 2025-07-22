
resource "aws_security_group_rule" "ansible_instance_ingress_rule" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = "sg-1234567"
}

resource "aws_key_pair" "ec2-keypair" {
  key_name   = "ec2-key"
  public_key = file("C:\\Users\\saradha.b\\Documents\\cloud\\test.pub")
}

resource "aws_instance" "ansible_control_node" {
  ami           = "ami-1234567"
  instance_type = "t3.micro"
  associate_public_ip_address = true
  key_name      = aws_key_pair.ec2-keypair.key_name
  tags = {
    Name = "ansible_control_node"
  }

   connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("C:\\Users\\saradha.b\\Documents\\cloud\\aws-per-server-2")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ 
        "apt update",

        # Install python3 if not installed
        "if ! command -v python3 >/dev/null 2>&1; then",
        "   sudo apt update && sudo apt install -y python3",
        "else",
        "   echo 'Python3 is installed'",
        "fi",

        # Install pip3 if not installed
        "if ! command -v pip3 >/dev/null 2>&1; then",
        "   sudo apt update && sudo apt install -y python3-pip",
        "else",
        "   echo 'pip is already installed'",
        "fi",

         # Install ansible using pip3
        "python3 -m pip install --user ansible",

        # Check ansible version with full PATH
        "PATH=$HOME/.local/bin:$PATH ansible --version"
     ]
    
  }
}