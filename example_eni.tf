provider "aws" {
  region = "us-west-2"
}
data "aws_instance" "sensor" {
  instance_id = ""
}
data "aws_instance" "mirror_src" {
  instance_id = "i-09284d50d017dca56"
}
module "traffic_mirror" {
  source               = "./modules/traffic_mirror_nlb"
  sensor_targ          = data.aws_instance.sensor.network_interface_id
  mirror_targ_desc     = "Test Terraform Module Target"
  mirror_filt_desc     = "Test Terraform Module Filter"
  mirror_session_desc  = "Test Terraform Module Session"
  mirror_instance_name = data.aws_instance.mirror_src.network_interface_id
  mirror_session_num   = 3
}
