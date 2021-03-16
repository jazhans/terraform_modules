resource "aws_ec2_traffic_mirror_target" "module_target" {
  description               = var.mirror_targ_desc
  network_load_balancer_arn = var.nlb_name
}
resource "aws_ec2_traffic_mirror_filter" "module_filter" {
  description = var.mirror_filt_desc
}
resource "aws_ec2_traffic_mirror_filter_rule" "module_outbound" {
  description              = "Capture all outbound"
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.module_filter.id
  destination_cidr_block   = "0.0.0.0/0"
  source_cidr_block        = "0.0.0.0/0"
  rule_number              = 1
  rule_action              = "accept"
  traffic_direction        = "egress"
}
resource "aws_ec2_traffic_mirror_filter_rule" "module_inbound" {
  description              = "Capture all inbound"
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.module_filter.id
  destination_cidr_block   = "0.0.0.0/0"
  source_cidr_block        = "0.0.0.0/0"
  rule_number              = 1
  rule_action              = "accept"
  traffic_direction        = "ingress"
}
resource "aws_ec2_traffic_mirror_session" "module_session" {
  description              = var.mirror_session_desc
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.module_filter.id
  traffic_mirror_target_id = aws_ec2_traffic_mirror_target.module_target.id
  network_interface_id     = var.mirror_instance_name
  session_number           = var.mirror_session_num
}
