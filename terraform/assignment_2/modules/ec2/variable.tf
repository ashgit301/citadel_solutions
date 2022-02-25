variable "ami_id" {
  type = string
  default = "ami-033b95fb8079dc481"
  description = "The id of the machine image (AMI) to use for the server."
}

variable "instance_type" {
  type = string 
  default = "t2.micro"
  description = "The instance type of the the particular machine image" 
}

