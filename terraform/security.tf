resource "aws_security_group" "example_ecs_sg" {
  name        = "example-ecs-sg"
  description = "Allow inbound traffic for ECS"
  vpc_id      = aws_vpc.example_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #パブリックサブネットなので
  }#httpsになってる
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "example_rds_sg" {
  name        = "example-rds-sg"
  description = "Allow inbound traffic for RDS"
  vpc_id      = aws_vpc.example_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # VPCのCIDRを指定(プライベートサブネットなので)
  }
}

