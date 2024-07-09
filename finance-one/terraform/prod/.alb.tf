resource "aws_lb_target_group" "tg_lb_wordpress_stage" {
  name     = "wordpress-stage"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network.vpc_id
  tags     = {}
  tags_all = {}
  target_type = "alb"

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200,301"
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 5
  }

  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }
}

# resource "aws_lb_target_group_attachment" "att_lb_wordpress_stage" {
#   target_group_arn = aws_lb_target_group.tg_lb_wordpress_stage.arn
#   target_id        = aws_instance.wordpress.id
#   port             = 80
# }

resource "aws_lb" "lb_wordpress_stage" {
  # arn                        = "arn:aws:elasticloadbalancing:us-east-1:186267377292:loadbalancer/app/wordpress-stage/5624dd353d7e6a52"
  # arn_suffix                 = "app/wordpress-stage/5624dd353d7e6a52"
  # desync_mitigation_mode     = "defensive"
  # dns_name                   = "wordpress-stage-211921372.us-east-1.elb.amazonaws.com"
  # drop_invalid_header_fields = false
  enable_deletion_protection = false
  # enable_http2               = true
  # enable_waf_fail_open       = false
  # id                         = "arn:aws:elasticloadbalancing:us-east-1:186267377292:loadbalancer/app/wordpress-stage/5624dd353d7e6a52"
  # idle_timeout               = 60
  internal                   = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  name               = "wordpress-stage"
  # preserve_host_header       = false
  security_groups = [aws_security_group.allow_http_in.id]
  subnets = [
    "subnet-033918fd1a76be813",
    "subnet-0ad4eb3bc48fe83b6",
  ]
  tags = {
    "Environment" = "stage"
    "Name"        = "wordpress-stage"
  }
  tags_all = {
    "Environment" = "stage"
    "Name"        = "wordpress-stage"
  }
  # vpc_id                     = "vpc-0fb433af4ef9b0815"
  # zone_id                    = "Z35SXDOTRQ7X7K"

  # access_logs {
  #     bucket  = aws_s3_bucket.lb-logs.bucket
  #     prefix  = "lb-wordpress-stage"
  #     enabled = true
  # }

  # subnet_mapping {
  #     subnet_id = "subnet-033918fd1a76be813"
  # }
  # subnet_mapping {
  #     subnet_id = "subnet-0ad4eb3bc48fe83b6"
  # }
}
#   name               = "wordpress-stage"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.allow_http_in.id]
#   subnets            = module.network.public_subnets[*]

#   enable_deletion_protection = false

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.bucket
#     prefix  = "lb-wordpress-stage"
#     enabled = true
#   }

#   tags = {
#     Environment = "stage"
#   }


# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
# }