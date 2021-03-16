provider "aws" {
  region = "us-west-2" # example region 
}
data "aws_lb" "test" {
  arn  = aws_lb.ise-nlb-zk.arn # example nlb 
}
data "aws_instance" "test" {
  instance_id = "i-09284d50d017dca56" # example instance id 
}
module "traffic_mirror" {
  source               = "./modules/traffic_mirror_nlb"
  nlb_name             = data.aws_lb.test.arn
  mirror_targ_desc     = "Test Terraform Module Target"
  mirror_filt_desc     = "Test Terraform Module Filter"
  mirror_session_desc  = "Test Terraform Module Session"
  mirror_instance_name = data.aws_instance.test.network_interface_id
  mirror_session_num   = 3
}
