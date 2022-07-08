terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_launch_template" "xmpp_server_template" {
  name_prefix          = "xmpp-server-"
  image_id             = "ami-052efd3df9dad4825"
  instance_type        = "t2.micro"
  key_name             = "lm-kp"
  security_group_names = [aws_security_group.lm-sg.name]
  user_data            = base64encode(data.template_cloudinit_config.config.rendered)
}

resource "aws_instance" "app_server_master" {
  availability_zone = "us-east-1a"
  ami               = "ami-052efd3df9dad4825"
  instance_type     = "t2.micro"
  key_name          = "lm-kp"
  security_groups   = [aws_security_group.lm-sg.name]
  user_data         = file("ejabberd.sh")
  tags = {
    Name = var.instance_name
  }

  #  launch_template {
  #    id = aws_launch_template.xmpp_server_template.id
  #  }
}

#resource "aws_instance" "app_server2" {
#  availability_zone = "us-east-1d"
#  depends_on        = [aws_instance.app_server_master]
#  user_data         = data.template_cloudinit_config.config.rendered
#  tags = {
#    Name = "lm-xmpp-server-02"
#  }
#
#  launch_template {
#    id = aws_launch_template.xmpp_server_template.id
#  }
#}

resource "aws_lb" "lm-lb" {
  name               = "lm-load-balancer"
  internal           = false
  load_balancer_type = "network"
  #    subnets            = [for subnet in aws_subnet.public : subnet.id]
  subnets = ["subnet-0fdf55f3dbad2b1a2", "subnet-07ad9f30962909ead", "subnet-0b5ace1a22216d42b",
  "subnet-02e6cef690eac708c", "subnet-0c730f685cf03d683", "subnet-042742ebd4553eaf4"]
}

resource "aws_lb_target_group" "lm-lb-tg" {
  name        = "lm-target-group"
  port        = 5222
  protocol    = "TCP"
  vpc_id      = "vpc-078e8a3dd5e838865"
  target_type = "instance"

}

resource "aws_lb_target_group_attachment" "lm-lb-tg-attachment-1" {
  target_group_arn = aws_lb_target_group.lm-lb-tg.arn
  target_id        = aws_instance.app_server_master.id
}

#resource "aws_lb_target_group_attachment" "lm-lb-tg-attachment-2" {
#  target_group_arn = aws_lb_target_group.lm-lb-tg.arn
#  target_id        = aws_instance.app_server2.id
#}

resource "aws_lb_listener" "lm-lb-listener" {
  load_balancer_arn = aws_lb.lm-lb.arn
  port              = "5222"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lm-lb-tg.arn
  }
}
