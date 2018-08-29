variable "access_key"     {}
variable "secret_key"     {}
variable "region"         {default = "us-east-1"}

#vars for VPC
variable "vpc_name"       {default = "kf_vpc"}
variable "vpc_cidr"       {default = "10.0.0.0/16"}

#IGW variables
variable "igw_name"       {default = "kf_igw" }

#NACL variables
variable "nacl_name"      {default = "kf_nacl" }
variable "nacl_cidr"      {default = "0.0.0.0/0"}

#RT variables
variable "route_name"     { default = "kf_route"}
variable "rt_cidr"        {default = "0.0.0.0/0"}

#SUBNET variables
variable "subnet1_name"   {default = "kf_public_subnet1"}
variable "subnet2_name"   {default = "kf_public_subnet2"}
variable "subnet1_cidr"   {default = "10.0.0.0/24"}
variable "subnet2_cidr"   {default = "10.0.1.0/24"}
variable "subnet1_az"     {default = "us-east-1a"}
variable "subnet2_az"     {default = "us-east-1b"}

#SG variables
variable "sg_cidr"        {default = ["0.0.0.0/0"]}
variable "sg_name"        {default = "kf_securiry_group"}

#ELB variables
variable "elb_name"       {default = "kf-elb"}
variable "interval"       {default = 5}

#S3 variables
variable "bucket"         {default = "kf-s3-logging-test"}


#vars for instance
variable "key_name" {
  default = "N_Virginia_filatko"
}
variable "public_key_path" {
  default = "/home/kfilatau/LEARN/Terraform/Terraform_git/task_modules/keys/N_Virginia_filatko.pub"
}
variable "private_key_path" {
  default = "/home/kfilatau/LEARN/Amazon/keys/N_Virginia_filatko.pem"
}
variable "ami"            {default = "ami-da05a4a0"}
variable "user"           {default = "ubuntu"}
variable "user_pem"       {default = "/home/kfilatau/LEARN/Chef/chef_git/.chef/filatoff.pem"}
variable "chef_node_name" {default = "kf_tf_test"}
# variable "ansible_private_key" {default = "/home/kfilatau/EPAM/LEARN/Ansible/N_Virginia_filatko.pem"}

# #ASG variables
# variable "asg_name"       {default = "kf_asg"}
# variable "ami"            {default = "ami-da05a4a0"}
# variable "instance_type"  {default = "t2.micro"}
# variable "min_size"       {default = 2}
# variable "max_size"       {default = 4}
