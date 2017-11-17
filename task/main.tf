provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
}

#creating VPC 
resource "aws_vpc" "kf_vpc" {
    cidr_block = "10.0.0.0/16"
    tags {
        Name = "kf_vpc"
    }
}

#creating INTERNET GATEWAY
resource "aws_internet_gateway" "kf_igw" {
    vpc_id = "${aws_vpc.kf_vpc.id}"
    tags = {
        "Name" = "kf_igw"
    }
}

#creating NACL
resource "aws_network_acl" "kf_nacl" {
    vpc_id = "${aws_vpc.kf_vpc.id}"
    subnet_ids = ["${aws_subnet.kf_public_subnet1.id}","${aws_subnet.kf_public_subnet2.id}"]
    egress {
        protocol = "-1"
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }

    ingress {
        protocol = "tcp"
        rule_no = 100
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 80
        to_port = 80
    }

    ingress {
        protocol = "tcp"
        rule_no = 110
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 22
        to_port = 22
    }

#Allows inbound return traffic from hosts on the Internet that are responding to requests originating in the subnet.
    ingress {
        protocol = "tcp"
        rule_no = 120
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 1024
        to_port = 65535
    }

    tags {
        Name = "kf_nacl"
    }
}

#creating ROUTE TABLES
resource "aws_route_table" "kf_route" {
    vpc_id = "${aws_vpc.kf_vpc.id}"
    route {
        gateway_id = "${aws_internet_gateway.kf_igw.id}"
        cidr_block    = "0.0.0.0/0"
    }
}

#creating ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "kf_route_table_association1" {
  subnet_id      = "${aws_subnet.kf_public_subnet1.id}"
  route_table_id = "${aws_route_table.kf_route.id}"
}

#creating ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "kf_route_table_association2" {
  subnet_id      = "${aws_subnet.kf_public_subnet2.id}"
  route_table_id = "${aws_route_table.kf_route.id}"
}

#creating SUBNET1
resource "aws_subnet" "kf_public_subnet1" {
    vpc_id = "${aws_vpc.kf_vpc.id}"
    cidr_block = "10.0.0.0/24"
    tags = {
        "Name" ="kf_public_subnet1"
    }
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"
}

#creating SUBNET2
resource "aws_subnet" "kf_public_subnet2" {
    vpc_id = "${aws_vpc.kf_vpc.id}"
    cidr_block = "10.0.1.0/24"
    tags = {
        "Name" ="kf_public_subnet2"
    }
    map_public_ip_on_launch = true
    availability_zone = "us-east-1b"
}

#creating SECURITY GROUP
resource "aws_security_group" "kf_security_group" {
    vpc_id = "${aws_vpc.kf_vpc.id}"

    egress {
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        from_port = "0"
        to_port = "0"
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 80
        to_port     = 80
    }

    tags {
        Name = "kf_securiry_group"
    }
}

resource "aws_elb" "kf_elb" {
    name = "kf-elb"

    subnets         = ["${aws_subnet.kf_public_subnet1.id}","${aws_subnet.kf_public_subnet2.id}"]
    security_groups = ["${aws_security_group.kf_security_group.id}"]
    instances       = ["${aws_instance.kf_inst1.id}","${aws_instance.kf_inst2.id}"]
    depends_on      = ["aws_s3_bucket.kf_S3_logging"]
    cross_zone_load_balancing   = true
    access_logs {
        bucket        = "kf_S3_logging"
 #       bucket_prefix = "bar"
        interval      = 5
    }
    listener {
        instance_port     = 80
        instance_protocol = "http"
        lb_port           = 80
        lb_protocol       = "http"
    }
}

resource "aws_s3_bucket" "kf_S3_logging" {
    bucket = "kf_S3_logging"
    force_destroy = true
    tags {
        Name        = "kf_S3_logging"
    }
    # logging {
    #     target_bucket = "${aws_s3_bucket.kf_S3_logging.id}"
    #     target_prefix = "log/"
    # }
}

resource "aws_s3_bucket_policy" "kf_S3_logging" {
    bucket = "${aws_s3_bucket.kf_S3_logging.id}"

    policy =<<POLICY
{
  "Id": "Policy1510836277408",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1510836271067",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::kf_S3_logging/*",
      "Principal": {
        "AWS": [
          "127311923021"
        ]
      }
    }
  ]
}
POLICY
}

resource "aws_key_pair" "kf_key_pair" {
    key_name   = "${var.key_name}"
    public_key = "${file(var.public_key_path)}"
}

#creating INSTANCE1
resource "aws_instance" "kf_inst1" {
    key_name = "${var.key_name}"
    connection = {
        user = "ubuntu"
        private_key = "${file(var.private_key_path)}"
    }
    ami           = "${var.amis["us-east-1"]}"
    instance_type = "t2.micro"
    tags {	
        Name = "kf_inst1"
    }
    vpc_security_group_ids = ["${aws_security_group.kf_security_group.id}"]
    subnet_id = "${aws_subnet.kf_public_subnet1.id}"
    provisioner "file" {
        source      = "html/nginx_homepage_1.html"
        destination = "/home/ubuntu/nginx_homepage_1.html"
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
    key_name = "${var.key_name}"
    connection = {
        user = "ubuntu"
        private_key = "${file(var.private_key_path)}"
    }
    ami           = "${var.amis["us-east-1"]}"
    instance_type = "t2.micro"
    tags {  
        Name = "kf_inst2"
    }
    vpc_security_group_ids = ["${aws_security_group.kf_security_group.id}"]
    subnet_id = "${aws_subnet.kf_public_subnet2.id}"
    provisioner "file" {
        source      = "html/nginx_homepage_2.html"
        destination = "/home/ubuntu/nginx_homepage_2.html"
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

output "elb_dns" {
 value = "${aws_elb.kf_elb.dns_name}"
}





































############################################################################################

#resource "aws_s3_bucket" "example" {
#  bucket = "filatko-test-bucket1"
#  acl    = "private"
#}



#  depends_on = ["aws_s3_bucket.example"]


# ${var.amis["us-east-1"]}

# ${lookup(var.amis, var.region)}


#resource "aws_eip" "kf_ip" {
#  instance = "${aws_instance.kf_inst1.id}"
#}

#output "ip" {
#  value = "${aws_eip.kf_ip.public_ip}"
#}