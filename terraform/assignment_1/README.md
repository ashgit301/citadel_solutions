[From Citadel]

Setup a WordPress application on apache web-server installed in EC2 instance via user_data template. Create and attach ELB to the EC2 instance for traffic routing and similarly create an RDS Mysql database with user credentials to configure the WordPress application.

[Solution - To be Noted]

No VPC & Subnet created - Using default VPC
No ASG created - Two EC2 created and attached to the LB 
AWS Creds will be passed as TF_variables at the time of execution 



