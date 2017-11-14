# Terraform_task
Terraform + AWS

Please create terraform template for orchestration high available, fault tolerance system in AWS, terraform template(s) should have module structure and be able to manage such AWS components as: 
- VPC
- NACL
- Subnets
- Security Groups
- 2 EC2 t2.micro in different subnets with installed nginx and some custom home page
- ELB in front of EC2 instances
- ELB logs to S3
