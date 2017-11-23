variable "route_name" {default = "kf_route"}
variable "vpc_id"     {}
variable "igw_id"     {}
variable "rt_cidr"    {}
variable "subnet1_id" {}
variable "subnet2_id" {}

#creating ROUTE TABLES
resource "aws_route_table" "kf_route" {
    vpc_id          = "${var.vpc_id}"
    route {
        gateway_id  = "${var.igw_id}"
        cidr_block  = "${var.rt_cidr}"
    }
}

#creating ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "kf_route_table_association1" {
  subnet_id         = "${var.subnet1_id}"
  route_table_id    = "${aws_route_table.kf_route.id}"
}

#creating ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "kf_route_table_association2" {
  subnet_id         = "${var.subnet2_id}"
  route_table_id    = "${aws_route_table.kf_route.id}"
}
