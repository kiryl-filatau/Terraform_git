variable "elb_name"         {default = "kf-elb"}
variable "subnets"          {
    type = "list"
}
variable "security_groups"  {}
variable "instances"        {
    type = "list"
}
variable "bucket_elb"       {default = "kf_S3_logging"}
variable "interval"         {default = 5}
variable "bucket_id"        {}

#creating ELB
resource "aws_elb" "kf_elb" {
    name = "${var.elb_name}"
    subnets                     = ["${var.subnets}"]
    security_groups             = ["${var.security_groups}"]
    instances                   = ["${var.instances}"]
    cross_zone_load_balancing   = true
    access_logs {
        bucket                  = "${var.bucket_elb}"
        interval                = "${var.interval}"
    }
    listener {
        instance_port           = 80
        instance_protocol       = "http"
        lb_port                 = 80
        lb_protocol             = "http"
    }
}

output "elb_dns" {value         = "${aws_elb.kf_elb.dns_name}"
}