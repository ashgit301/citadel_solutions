output "vpc_id" {
  value = aws_vpc.citadel-vpc.id
}
output "public_subnet_id" {
  value = aws_subnet.subnet-public[*].id
}
output "private_subnet_id" {
  value = aws_subnet.subnet-private[*].id
}
output "security_group_id" {
  value = aws_security_group.security-group.id
}
output "db_subnet_name" {
  value = aws_db_subnet_group.db_subnet_group.name 
}
  
