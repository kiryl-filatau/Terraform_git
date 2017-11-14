variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "us-east-1"
}
variable "amis" {
    type = "map"
    default = {
        "us-east-1" = "ami-da05a4a0"
        "us-east-2" = "ami-aa1b34cf"
    }
}
variable "key_name" {
  default = "N_Virginia_filatko"
}
variable "public_key_path" {
  default = "/home/kfilatau/EPAM/LEARN/Terraform/Terraform_task/task/keys/N_Virginia_filatko.pub"
}
variable "private_key_path" {
  default = "/home/kfilatau/EPAM/LEARN/Amazon/keys/N_Virginia_filatko.pem"
}