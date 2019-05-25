variable "vpc_id"   {}
variable "sg_cidr"  {default = ["0.0.0.0/0"]}
variable "sg_name"  {default = "kf_securiry_group"}

#creating SECURITY GROUP
resource "aws_security_group" "kf_security_group" {
    vpc_id          = "${var.vpc_id}"

    egress {
        protocol    = "-1"
        cidr_blocks = "${var.sg_cidr}"
        from_port   = "0"
        to_port     = "0"
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = "${var.sg_cidr}"
    }

    ingress {
        protocol    = "tcp"
        cidr_blocks = "${var.sg_cidr}"
        from_port   = 80
        to_port     = 80
    }

    tags = {
        Name        = "${var.sg_name}"
    }
}

output "sg_id" {
    value           = "${aws_security_group.kf_security_group.id}"
}