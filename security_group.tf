resource "aws_security_group" "lm-sg" {
  name        = "allow_ssh_and_xmpp"
  description = "Allow SSH and XMPP inbound traffic"
  vpc_id      = "vpc-078e8a3dd5e838865"

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "XMPP from VPC"
    from_port   = 5222
    to_port     = 5222
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Temporary all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_xmpp"
  }
}