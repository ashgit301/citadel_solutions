resource "aws_db_instance" "testdb" {
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  db_name                = "citadelpostgres"
  username               = "citadel"
  password               = "citadel1234"
  skip_final_snapshot  = true
}
