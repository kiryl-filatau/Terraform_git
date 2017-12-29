variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "us-east-1"
}
variable "amis" {
    type = "map"
    default = {
        "us-east-1" = "ami-c29e1cb8"
        "us-east-2" = "ami-aa1b34cf"
    }
}
variable "key_name" {
  default = "N_Virginia_filatko"
}
variable "public_key_path" {
  default = "/home/kfilatau/EPAM/LEARN/Terraform/Terraform_git/chef/keys/N_Virginia_filatko.pub"
}
variable "private_key_path" {
  default = "/home/kfilatau/EPAM/LEARN/Amazon/keys/N_Virginia_filatko.pem"
}

variable "ami"            {default = "ami-da05a4a0"}
# # VPC variables
# variable "vpc_name" { default = "kf_vpc"}
# variable "kf_vpc_cidr" { default = "10.0.0.0/16"}

# #IGW variables
# variable "igw_name" {default = "kf_igw"}
# variable "igw_id" {}

# #NACL variables
# variable "nacl_name" {default = "kf_nacl"}
# variable "nacl_cidr" {default = "0.0.0.0/0"}

# #RT variables
# variable "rt_cidr" {default = "0.0.0.0/0"}
# variable "kf_route_id" {}