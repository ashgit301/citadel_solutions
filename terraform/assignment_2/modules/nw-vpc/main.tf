resource “aws_vpc” “citadel-vpc” {
    cidr_block = “10.0.0.0/16”
    enable_dns_support = “true” 
    enable_dns_hostnames = “true”
    tags {
        Name = “citadel-vpc”
    }
}

resource “aws_subnet” “subnet-public” {
    count = 3 
    vpc_id = aws_vpc.citadel-vpc.id
    cidr_block = var.public_subnet[count.index]
    map_public_ip_on_launch = “true”
    tags {
        Name = “subnet-public-${count.index}”
    }
}

resource “aws_subnet” “subnet-private” {
    count = 3 
    vpc_id = aws_vpc.citadel-vpc.id
    cidr_block = var.private_subnet[count.index]
    map_public_ip_on_launch = false
    tags {
        Name = “subnet-private-${count.index}”
    }
}

resource "aws_internet_gateway" "citadel-igw" {
    vpc_id = "${aws_vpc.citadel-vpc.id}"
    tags {
        Name = "citadel-igw"
    }
}

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.citadel-igw]
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.subnet-private.*.id, 0)

  tags = {
    Name = "citadel-NAT"
  }

  depends_on = [aws_internet_gateway.example]
}

resource "aws_route_table" "citadel-public-crt" {
    vpc_id = "${aws_vpc.main-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = "${aws_internet_gateway.citadel-igw.id}" 
    }
    
    tags {
        Name = "citadel-public-crt"
    }
}

resource "aws_route_table" "citadel-private-crt" {
  vpc_id = aws_vpc.vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id         = aws_nat_gateway.nat.id
  }

  tags = {
    Name        = "citadel-private-crt"
  }

}

resource "aws_route_table_association" "crta-public-subnet"{
    count = 3
    subnet_id = element(aws_subnet.subnet-public.*.id)
    route_table_id = "${aws_route_table.citadel-public-crt.id}"
}

resource "aws_route_table_association" "crta-private-subnet"{
    count = 3 
    subnet_id = element(aws_subnet.subnet-private.*.id
    route_table_id = "${aws_route_table.citadel-private-crt.id}"
}


resource "aws_db_subnet_group" "db_subnet_group" {
  name = "db_subnet_group"
  subnet_ids = aws_subnet.subnet-private.*.id
}

resource "aws_security_group" "security-group" {
  vpc_id = aws_vpc.citadel-vpc.id

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "rds"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
