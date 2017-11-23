variable "vpc_id"       {}
variable "subnet1_name" {default = "kf_public_subnet1"}
variable "subnet2_name" {default = "kf_public_subnet2"}
variable "subnet1_cidr" {default = "10.0.0.0/24"}
variable "subnet2_cidr" {default = "10.0.1.0/24"}
variable "subnet1_az"   {default = "us-east-1a"}
variable "subnet2_az"   {default = "us-east-1b"}

#creating SUBNET1
resource "aws_subnet" "kf_public_subnet1" {
    vpc_id                  = "${var.vpc_id}"
    cidr_block              = "${var.subnet1_cidr}"
    tags = {
        "Name"              = "${var.subnet1_name}"
    }
    map_public_ip_on_launch = true
    availability_zone       = "${var.subnet1_az}"
}

#creating SUBNET2
resource "aws_subnet" "kf_public_subnet2" {
    vpc_id                  = "${var.vpc_id}"
    cidr_block              = "${var.subnet2_cidr}"
    tags = {
        "Name"              = "${var.subnet2_name}"
    }
    map_public_ip_on_launch = true
    availability_zone       = "${var.subnet2_az}"
}

output "subnet_ids" {value  = "${list(aws_subnet.kf_public_subnet1.id, aws_subnet.kf_public_subnet2.id)}"}
output "subnet1_id" {value  = "${aws_subnet.kf_public_subnet1.id}"}
output "subnet2_id" {value  = "${aws_subnet.kf_public_subnet2.id}"}