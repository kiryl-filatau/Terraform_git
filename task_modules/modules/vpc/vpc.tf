variable "vpc_name" { default = "kf_vpc"}
variable "vpc_cidr" {default = "10.0.0.0/16"}

#creating VPC 
resource "aws_vpc" "kf_vpc" {
    cidr_block  = "${var.vpc_cidr}"
    tags {
        Name    = "${var.vpc_name}"
    }
}

output "vpc_id" { value = "${aws_vpc.kf_vpc.id}" }
