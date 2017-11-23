#creating KEY PAIR
variable "key_name"                 {}
variable "public_key_path"          {}
variable "private_key_path"         {}
variable "ami"                      {default = "ami-da05a4a0"}
variable "user"                     {default = "ubuntu"}
variable "sg_id"                    {}
variable "subnet_id_1"              {}
variable "subnet_id_2"              {}

resource "aws_key_pair" "kf_key_pair" {
    key_name                = "${var.key_name}"
    public_key              = "${file(var.public_key_path)}"
}

#creating INSTANCE1
resource "aws_instance" "kf_inst1" {
    key_name                = "${var.key_name}"
    connection = {
        user                = "${var.user}"
        private_key         = "${file(var.private_key_path)}"
    }
    ami                     = "${var.ami}"
    instance_type           = "t2.micro"
    tags {  
        Name                = "kf_inst1"
    }
    vpc_security_group_ids  = ["${var.sg_id}"]
    subnet_id               = "${var.subnet_id_1}"
    provisioner "file" {
        source              = "modules/instances/html/nginx_homepage_1.html"
        destination         = "/home/ubuntu/nginx_homepage_1.html"
    } 
    provisioner "remote-exec" {
        inline = [
            "sudo apt-get -y update",
            "sudo apt-get -y install nginx",
            "sudo service nginx start",
            "sudo mv /home/ubuntu/nginx_homepage_1.html /var/www/html/index.nginx-debian.html"
        ]
    }
}

#creating INSTANCE2
resource "aws_instance" "kf_inst2" {
    key_name                = "${var.key_name}"
    connection = {
        user                = "ubuntu"
        private_key         = "${file(var.private_key_path)}"
    }
    ami                     = "${var.ami}"
    instance_type           = "t2.micro"
    tags {  
        Name                = "kf_inst2"
    }
    vpc_security_group_ids  = ["${var.sg_id}"]
    subnet_id               = "${var.subnet_id_2}"
    provisioner "file" {
        source              = "modules/instances/html/nginx_homepage_2.html"
        destination         = "/home/ubuntu/nginx_homepage_2.html"
    }    
    provisioner "remote-exec" {
        inline = [
            "sudo apt-get -y update",
            "sudo apt-get -y install nginx",
            "sudo service nginx start",
            "sudo mv /home/ubuntu/nginx_homepage_2.html /var/www/html/index.nginx-debian.html"
        ]
    }
}

output "instances_ids" {value = "${list(aws_instance.kf_inst1.id, aws_instance.kf_inst2.id)}"}