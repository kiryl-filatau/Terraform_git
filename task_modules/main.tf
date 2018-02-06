provider "aws" {
    access_key      = "${var.access_key}"
    secret_key      = "${var.secret_key}"
    region          = "${var.region}"
}

module "kf_vpc" {
    source          = "./modules/vpc"

    vpc_name        = "${var.vpc_name}"
    vpc_cidr        = "${var.vpc_cidr}"
}

module "kf_igw" {
    source          = "./modules/igw"

    igw_name        = "${var.igw_name}"
    vpc_id          = "${module.kf_vpc.vpc_id}"
}

module "kf_nacl" {
    source          = "./modules/nacl"

    nacl_name       = "${var.nacl_name}"
    vpc_id          = "${module.kf_vpc.vpc_id}"
    subnet_ids      = "${module.kf_subnets.subnet_ids}"
    nacl_cidr       = "${var.nacl_cidr}"
}

module "kf_rt" {
    source          = "./modules/route_tables"

    route_name      = "${var.route_name}"
    vpc_id          = "${module.kf_vpc.vpc_id}"
    igw_id          = "${module.kf_igw.igw_id}"
    rt_cidr         = "${var.rt_cidr}"
    subnet1_id      = "${module.kf_subnets.subnet1_id}"
    subnet2_id      = "${module.kf_subnets.subnet2_id}"
}

module "kf_subnets" {
    source          = "./modules/subnets"

    vpc_id          = "${module.kf_vpc.vpc_id}"
    subnet1_name    = "${var.subnet1_name}"
    subnet2_name    = "${var.subnet2_name}"
    subnet1_cidr    = "${var.subnet1_cidr}"
    subnet2_cidr    = "${var.subnet2_cidr}"
    subnet1_az      = "${var.subnet1_az}"
    subnet2_az      = "${var.subnet2_az}"
}

module "kf_sg" {
    source          = "./modules/security_groups"

    vpc_id          = "${module.kf_vpc.vpc_id}"
    sg_cidr         = "${var.sg_cidr}"
    sg_name         = "${var.sg_name}"
}

module "kf_elb" {
    source          = "./modules/elb"

    elb_name        = "${var.elb_name}"
    subnets         = "${module.kf_subnets.subnet_ids}"
    security_groups = "${module.kf_sg.sg_id}"
    instances       = "${module.kf_instances.instances_ids}"
    bucket_elb      = "${module.kf_S3.depends_on_bucket_policy}"
    interval        = "${var.interval}"
}

module "kf_S3" {
    source          = "./modules/s3"

    bucket          = "${var.bucket}"
    bucket_id       = "${module.kf_S3.bucket_id}"
}

# module "kf_asg" {
#     source = "./modules/asg"

#     key_name        = "${var.key_name}"
#     public_key_path = "${var.public_key_path}"
#     asg_name        = "${var.asg_name}"
#     ami             = "${var.ami}"
#     instance_type   = "${var.instance_type}"
#     asg_sg          = "${module.kf_sg.sg_id}"
#     min_size        = "${var.min_size}"
#     max_size        = "${var.max_size}"
#     load_balancers  = "${module.kf_elb.elb_id}"
#     subnet_ids      = "${module.kf_subnets.subnet_ids}"

# }

module "kf_instances" {
    source          = "./modules/instances"

    key_name        = "${var.key_name}"
    public_key_path = "${var.public_key_path}"
    private_key_path= "${var.private_key_path}"
    ami             = "${var.ami}"
    user            = "${var.user}"
    sg_id           = "${module.kf_sg.sg_id}"
    subnet_id_1     = "${module.kf_subnets.subnet1_id}"
    subnet_id_2     = "${module.kf_subnets.subnet2_id}"
    # data_bag_secret_path = "${var.data_bag_secret_path}"
    user_pem        = "${var.user_pem}"
    chef_node_name  = "${var.chef_node_name}"
    # ansible_private_key = "${var.ansible_private_key}"
}

output "elb_dns" {
    value           = "${module.kf_elb.elb_dns}"
}