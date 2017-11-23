variable "elb_name"         {default = "kf-elb"}
variable "subnets"          {}
variable "security_groups"  {}
variable "instances"        {}
variable "bucket_elb"           {default = "kf_S3_logging"}
variable "interval"         {default = 5}

#creating ELB
resource "aws_elb" "kf_elb" {
    name = "${var.elb_name}"
    subnets         = ["${var.subnets}"]
    security_groups = ["${var.security_groups}"]
    instances       = ["${var.instances}"]
    cross_zone_load_balancing   = true
    access_logs {
        bucket        = "${var.bucket_elb}"
 #       bucket_prefix = "bar"
        interval      = "${var.interval}"
    }
    listener {
        instance_port     = 80
        instance_protocol = "http"
        lb_port           = 80
        lb_protocol       = "http"
    }
}

output "elb_dns" {
 value = "${aws_elb.kf_elb.dns_name}"
}