resource "aws_db_instance" "test_db" {
  instance_class         = "db.t2.micro"
  allocated_storage      = 1
  engine                 = "postgres"
  name                   = postgres_rds
  username               = "citadel"
  password               = "citadel1234"
}
