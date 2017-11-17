#creating VPC 
resource "aws_vpc" "kf_vpc" {
    cidr_block = "${var.kf_vps_cidr}"
    tags {
        Name = "${var.vpc_name}"
    }
}

output "vpc_id"   { value = "${aws_vpc.kf_vpc.id}" }
output "vpc_cidr" { value = "${aws_vpc.kf_vpc.cidr_block}" }