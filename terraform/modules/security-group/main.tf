resource "aws_security_group" "security_group" {
  name   = var.group_name

  vpc_id = var.vpc_id

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 9000
    to_port   = 9000
    protocol  = "tcp"
  }

  # Redis
  ingress {
    protocol = "tcp"
    from_port = 6379
    to_port = 6379
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
