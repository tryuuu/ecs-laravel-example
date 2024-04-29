resource "aws_lb" "example_alb" {
  name               = "example-alb"
  internal           = false #ALBを外部に公開
  load_balancer_type = "application"
  security_groups    = [aws_security_group.example_alb_sg.id]
  subnets            = [aws_subnet.example_public_subnet_1.id, aws_subnet.example_public_subnet_2.id]

  enable_deletion_protection = false #削除保護無効

  tags = {
    Name = "example-alb"
  }
}

resource "aws_lb_target_group" "example_target_group" {
  name     = "example-tg"
  port     = 80 #ターゲットグループは80で受け付ける
  protocol = "HTTP"
  vpc_id   = aws_vpc.example_vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2 #ヘルスチェックの回数の設定
    timeout             = 3
    path                = "/" #アプリケーションによって異なる
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 30
  }
}

###ポート443でHTTPSトラヒックを受け付けるコードを後で書く

#ポート80でHTTPトラヒックを受け付け、ターゲットグループに転送するリスナーの作成
resource "aws_lb_listener" "example_listener" {
  load_balancer_arn = aws_lb.example_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example_target_group.arn
  }
}

resource "aws_security_group" "example_alb_sg" {
  name        = "example-alb-sg"
  description = "Allow web traffic to ALB"
  vpc_id      = aws_vpc.example_vpc.id
#全てのIPアドレスを許可
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

