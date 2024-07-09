resource "aws_launch_template" "wordpress-stage" {
  #   name_prefix   = "wordpress-stage-launch"
  name          = "wordpress-stage-launch"
  image_id      = "ami-0006dc5dd91d359cd"
  instance_type = "t2.small"
  security_group_names = [aws_security_group.allow_http_in.name]
  # default_version = "1"
  iam_instance_profile {
    name ="AmazonSSMRoleForInstancesQuickSetup"
  }
  monitoring {
    enabled = true
  }
  tags = {
    "Environment" = "stage"
    "Name"        = "wordpress-stage-launch"
  }
  tags_all = {
    "Environment" = "stage"
    "Name"        = "wordpress-stage-launch"
  }
  # vpc_security_group_ids  = []

  # network_interfaces {
  #   device_index       = 0
  #   ipv4_address_count = 0
  #   ipv4_addresses     = []
  #   ipv4_prefix_count  = 0
  #   ipv4_prefixes      = []
  #   ipv6_address_count = 0
  #   ipv6_addresses     = []
  #   ipv6_prefix_count  = 0
  #   ipv6_prefixes      = []
  #   network_card_index = 0
  #   security_groups = [aws_security_group.allow_http_in.name]
  # }

  tag_specifications {
    resource_type = "instance"
    tags = {
      "Environment" = "stage"
      "Name"        = "wordpress-stage-launch"
    }
  }
}

resource "aws_autoscaling_group" "wordpress-stage" {
  availability_zones = [
    "us-east-1a",
    "us-east-1b",
  ]
  # capacity_rebalance        = false
  # default_cooldown          = 300
  # default_instance_warmup   = 0
  # enabled_metrics           = []
  health_check_grace_period = 300
  health_check_type         = "ELB"
  # id                        = "wordpress-stage"
  # load_balancers            = []
  # max_instance_lifetime     = 0
  desired_capacity          = 1
  max_size = 1
  # metrics_granularity       = "1Minute"
  min_size = 1
  name     = "wordpress-stage"
  # protect_from_scale_in     = false
  # service_linked_role_arn   = "arn:aws:iam::186267377292:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
  # suspended_processes       = []
  target_group_arns = [
    "arn:aws:elasticloadbalancing:us-east-1:186267377292:targetgroup/wordpress-stage/203a4444bc3b50e9",
  ]
  # termination_policies      = []
  # vpc_zone_identifier       = [
  #     "subnet-033918fd1a76be813",
  #     "subnet-0ad4eb3bc48fe83b6",
  # ]

  launch_template {
    id      = aws_launch_template.wordpress-stage.id
    # name    = aws_launch_template.wordpress-stage.name
    version = aws_launch_template.wordpress-stage.latest_version
  }

  tag {
    key                 = "Environment"
    propagate_at_launch = true
    value               = "stage"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "wordpress-stage"
  }

  # timeouts {}
}