resource "aws_autoscaling_group" "lm_autoscaling_group" {
  availability_zones = ["us-east-1d", "us-east-1e"]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 1
  name_prefix        = "xmpp-server-"
  launch_template {
    id      = aws_launch_template.xmpp_server_template.id
    version = "$Latest"
  }
  depends_on        = [aws_instance.app_server_master]
  target_group_arns = [aws_lb_target_group.lm-lb-tg.arn]
}
