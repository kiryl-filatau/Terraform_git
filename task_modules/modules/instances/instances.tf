#creating KEY PAIR
variable "key_name"                 {}
variable "public_key_path"          {}
variable "private_key_path"         {}
variable "ami"                      {default = "ami-da05a4a0"}
variable "user"                     {default = "ubuntu"}
variable "sg_id"                    {}
variable "subnet_id_1"              {}
variable "subnet_id_2"              {}
# variable "data_bag_secret_path"     {}
variable "user_pem"                 {}
variable "chef_node_name"           {}
# variable "ansible_private_key"      {}

resource "aws_key_pair" "kf_key_pair" {
    key_name                = "${var.key_name}"
    public_key              = "${file(var.public_key_path)}"
}

#creating INSTANCE1
resource "aws_instance" "kf_inst1" {
    key_name                = "${var.key_name}"
    connection {
        host                = self.public_ip
        type                = "ssh"
        user                = "${var.user}"
        private_key         = "${file(var.private_key_path)}"
    }
    ami                     = "${var.ami}"
    instance_type           = "t2.micro"
    tags = {  
        Name                = "kf_inst1"
    }
    vpc_security_group_ids  = ["${var.sg_id}"]
    subnet_id               = "${var.subnet_id_1}"
    provisioner "file" {
        source              = "modules/instances/html/nginx_homepage_1.html"
        destination         = "/home/ubuntu/nginx_homepage_1.html"
    } 
    provisioner "chef" {
        # attributes_json = <<-EOF
        #   {
        #     "key": "value",
        #     "app": {
        #       "cluster1": {
        #         "nodes": [
        #           "webserver1",
        #           "webserver2",
        #           "webserver3",
        #           "webserver4"
        #         ]
        #       }
        #     }
        #   }
        # EOF

        # environment     = "_default"
        run_list        = ["terraform::default"]
        node_name       = "${format("%s-%02d", var.chef_node_name, count.index+1)}"
        # secret_key      = "${file("../encrypted_data_bag_secret")}"
        # secret_key      = "${file(var.data_bag_secret_path)}"
        server_url      = "https://api.chef.io/organizations/lollol"
        recreate_client = true
        user_name       = "filatoff"
        # user_key        = "${file("../bork.pem")}"
        user_key        = "${file(var.user_pem)}"
        version         = "12.16.42"
        # If you have a self signed cert on your chef server change this to :verify_none
        #ssl_verify_mode = ":verify_peer"
      }
      provisioner "local-exec" {
        when = "destroy"
        command = "cd /home/kfilatau/LEARN/Chef/chef_git/; knife node delete ${format("%s-%02d", var.chef_node_name, count.index+1)} -y; knife client delete ${format("%s-%02d", var.chef_node_name, count.index+1)} -y"
      }
      count             = 2
}

#creating INSTANCE2
resource "aws_instance" "kf_inst2" {
    key_name                = "${var.key_name}"
    connection {
        host                = self.public_ip
        type                = "ssh"
        user                = "ubuntu"
        private_key         = "${file(var.private_key_path)}"
    }
    ami                     = "${var.ami}"
    instance_type           = "t2.micro"
    tags = {  
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

#creating INSTANCE3
resource "aws_instance" "kf_inst3" {
    key_name                = "${var.key_name}"
    connection {
        host                = self.public_ip
        type                = "ssh"
        user                = "ubuntu"
        private_key         = "${file(var.private_key_path)}"
    }
    ami                     = "${var.ami}"
    instance_type           = "t2.micro"
    tags = {  
        Name                = "kf_inst3"
    }
    vpc_security_group_ids  = ["${var.sg_id}"]
    subnet_id               = "${var.subnet_id_2}"
    # provisioner "remote-exec" {
    #     inline = [
    #         "sudo apt -y update && sudo apt install -y python-minimal"
    #     ]
    # }
    # provisioner "local-exec" {
    #     command = "cd /home/kfilatau/EPAM/LEARN/Ansible/Ansible_git/; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key './N_Virginia_filatko.pem' -i '${aws_instance.kf_inst3.public_ip},' main.yml"
    provisioner "remote-exec" {
        inline = [
            "sudo apt -y update && sudo apt install -y python-minimal"
        ]
        
    }
    provisioner "local-exec" {
        command = "cd /home/kfilatau/LEARN/Ansible/Ansible_git/; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key './N_Virginia_filatko.pem' -i '${aws_instance.kf_inst3.public_ip},' main.yml"
    }
}


# output "instances_ids" {value = "${list(aws_instance.kf_inst1.*.id, aws_instance.kf_inst2.id)}"}

output "instances_ids" {value = ["${aws_instance.kf_inst1.*.id}", "${aws_instance.kf_inst2.id}", "${aws_instance.kf_inst3.id}"]}