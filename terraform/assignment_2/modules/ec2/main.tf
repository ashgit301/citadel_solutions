resource "aws_instance" "citadel_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = "citadel-terraform"
  tags = { 
    Name = "citadel_ec2"
  }
}

