variable "asg_name" {
    type            = "string"
    default         = "kf_asg"
}
variable "ami" {
    type            = "string"
    default         = "ami-da05a4a0"
}
variable "instance_type" {
    type            = "string"
    default         = "t2.micro"
}
variable "asg_sg" {
#    type            = "list"
}
variable "min_size" {
    type            = "string"
    default         = 2
}
variable "max_size" {
    type            = "string"
    default         = 4
}
variable "load_balancers" {
#    type = "list"
}
variable "key_name" {
    type            = "string"
    default         = "N_Virginia_filatko"
}
variable "public_key_path" {
  default           = "/home/kfilatau/EPAM/LEARN/Terraform/Terraform_task/task_modules/keys/N_Virginia_filatko.pub"
}
variable "subnet_ids" {
    type            = "list"
}




resource "aws_key_pair" "kf_key_pair" {
    key_name        = "${var.key_name}"
    public_key      = "${file(var.public_key_path)}"
}

resource "aws_launch_configuration" "kf_lc" {
    image_id        = "${var.ami}"
    instance_type   = "${var.instance_type}"
    security_groups = ["${var.asg_sg}"]
    key_name        = "${aws_key_pair.kf_key_pair.key_name}"
    user_data       = <<EOF
#!/bin/bash
sudo apt-get -y update
sudo apt-get -y install nginx
sudo service nginx start
sudo echo "hello, from Filatko" > /var/www/html/index.nginx-debian.html
EOF
    lifecycle {
        create_before_destroy = true
    }
}

# data "aws_availability_zones" "allzones" {}

resource "aws_autoscaling_group" "kf_asg" {
    launch_configuration    = "${aws_launch_configuration.kf_lc.name}"
    # availability_zones      = ["${data.aws_availability_zones.allzones.names}"]
    vpc_zone_identifier     = ["${var.subnet_ids}"]
    min_size                = "${var.min_size}"
    max_size                = "${var.max_size}"
    load_balancers          = ["${var.load_balancers}"]
    health_check_type       = "ELB"
    tag {
        key                 = "Name"
        value               = "kf_asg"
        propagate_at_launch = true
    }
}


