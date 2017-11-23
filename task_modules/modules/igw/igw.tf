variable "igw_name" { default = "kf_igw" }
variable "vpc_id"   {}

#creating INTERNET GATEWAY
resource "aws_internet_gateway" "kf_igw" {
    vpc_id = "${var.vpc_id}"
    tags = {
        "Name" = "${var.igw_name}"
    }
}

#output "igw_name" { value = "${aws_internet_gateway.kf_igw.Name}" }
output "igw_id" { value = "${aws_internet_gateway.kf_igw.id}" }