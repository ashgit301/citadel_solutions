provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "wordpress_server" {
  ami           = var.ami_id
  count 	= 2 
  instance_type = var.instance_type
  security_groups = [aws_security_group.wordpress_sg.id]
  user_data = file("user_data.sh")
  key_name = "citadel"
  tags = { 
    Name = "wordpress_server_${count.index}"
  }
}

resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress_sg"
  description = "Allow incoming traffic for the wordpress server"
 
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress_sg"
  }
}

resource "aws_security_group" "elb_sg" {
  name        = "lb_sg"
  description = "Allow incoming traffic for the lb"
 
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_elb" "wordpress_elb" {
  name = "wordpress-elb"
  security_groups = [aws_security_group.elb_sg.id]
  availability_zones = ["us-east-1"]
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }

  instances = [aws_instance.wordpress_server[1].id,aws_instance.wordpress_server[2].id]
  cross_zone_load_balancing = false
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags = {
    Name = "wordpress-elb"
  }
}

resource "aws_db_instance" "wordpress_backend" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "wordpress_backend"
  username             = "wordpress"
  password             = "citadel"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  availability_zone     = "us-east-1"
}

output "wordpress_ip_addr" {
  value = aws_instance.wordpress_server[*].public_ip
}
