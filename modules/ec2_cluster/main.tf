resource "aws_vpc" "module_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.business_unit}-${var.env_loc}-vpc-${var.app_name}"
    business_unit = var.business_unit
    Environment   = var.env_loc
  }
}
resource "aws_subnet" "module_subnets" {
  count             = var.subnet_count
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  vpc_id            = var.vpc_id # aws_vpc.ise-vpc-zk.id
  cidr_block        = element(var.private_subnets, count.index)
  tags = {
    Name = "${var.business_unit}-${var.env_loc}-subnet-${var.app_name}-${count.index + 1}"
    business_unit = var.business_unit
    Environment   = var.env_loc
  }
}
resource "aws_internet_gateway" "module_gateway" {
  vpc_id   = var.vpc_id
  tags = {
    Name          = "${var.business_unit}-${var.env_loc}-igw-${var.app_name}"
    business_unit = var.business_unit
    Environment   = var.env_loc
  }
}
resource "aws_route_table" "module_internet_route" {
  vpc_id   = var.vpc_id
  route {
    cidr_block = var.external-ip
    gateway_id = aws_internet_gateway.ise-igw-zk.id
  }
  tags = {
    Name          = "${var.business_unit}-${var.env_loc}-rt-${var.app_name}"
    business_unit = var.business_unit
    Environment   = var.env_loc
  }
}
resource "aws_main_route_table_association" "module_set_master_default_rt_assoc" {
  vpc_id         = aws_vpc.module_vpc.id
  route_table_id = aws_route_table.module_internet_route.id
}
resource "aws_security_group" "module_sg" {
  description = var.sg_desc
  vpc_id      = aws_vpc.module_vpc.id
  tags = {
    Name          = "${var.business_unit}-${var.env_loc}-sg-${var.app_name}"
    business_unit = var.business_unit
    Environment   = var.env_loc
  }
  ingress {
    description = "Allow 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_allow_in
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.cidr_allow_out
  }
}
resource "aws_instance" "module_instances" {
  count                       = var.instances_per_subnet
  ami                         = var.default_ami
  instance_type               = var.instance_type
  key_name                    = var.key_using # aws_key_pair.ise-ky-zk.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.sg_id] # [aws_security_group.ise-sg-zk.id]
  subnet_id                   = aws_subnet.module_subnets[count.index].id
  tags = {
    Name = "${var.business_unit}-${var.env_loc}-ec2-${var.app_name}-${count.index + 1}"
    business_unit = var.business_unit
    Environment   = var.env_loc
  }
}
#####################
#                   #
#####################
data "keystuff" {
  
}
data "sg stuff" {
  
}
module "ec2_cluster" {
  vpc_cidr             = "10.0.0.0/16"
  subnet_count         = 2
  instances_per_subnet = 2
  default_ami          = ""
  instance_type        = "tdklja"
  private_subnets      = ["10.0.4.0/24","10.0.5.0/24"]
  key_using            = data.
  sg_id                = data.
  business_unit        = "ise"
  env_loc              = "dev"
  app_name             = "zeek"
  ssh_allow_in         = ["0.0.0.0/0"]
  cidr_allow_out       = ["0.0.0.0/0"]
}