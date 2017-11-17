#creating ROUTE TABLES
resource "aws_route_table" "kf_route" {
    vpc_id = "${aws_vpc.kf_vpc.id}"
    route {
        gateway_id = "${var.igw_id}"
        cidr_block    = "${var.rt_cidr}"
    }
}

output "kf_route_id" {value = "${aws_route_table.kf_route.id}"}

#creating ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "kf_route_table_association1" {
  subnet_id      = "${aws_subnet.kf_public_subnet1.id}"
  route_table_id = "${var.kf_route_id}"
}

#creating ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "kf_route_table_association2" {
  subnet_id      = "${aws_subnet.kf_public_subnet2.id}"
  route_table_id = "${var.kf_route_id}"
}