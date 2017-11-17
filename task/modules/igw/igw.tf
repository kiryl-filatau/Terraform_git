#creating INTERNET GATEWAY
resource "aws_internet_gateway" "kf_igw" {
    vpc_id = "${var.vpc_id}"
    tags = {
        "Name" = "${var.igw_name}"
    }
}

output "igw_id" { value = "${aws_vpc.kf_igw.id}" }