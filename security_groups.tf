resource "aws_security_group" "load-balancer-security-group" {
  name_prefix = "load-balancer-security-group"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.kunal.id
  tags = {
    "Name" = "load balancer"
  }
}


resource "aws_autoscaling_group" "asg" {

  name = "csye6225-asg-spring2023"


  tag {

    key = "Name"

    value = "ASG"

    propagate_at_launch = true

  }

  desired_capacity = 1 

  min_size = 1

  max_size = 3 

  vpc_zone_identifier = [for o in aws_subnet.public_subnet : o.id]

  health_check_type = "ELB"

  launch_template {

    id = aws_launch_template.ec2-template.id

    version = "$Latest"

  }

  target_group_arns = [

    aws_lb_target_group.alb_tg.arn

  ]

}






resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 10
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "scale-up-alarm"
  alarm_description   = "Scale Up Alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "2"
  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.asg.name}"
  }
  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.scale_up_policy.arn}"]
}



resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 30
  autoscaling_group_name = aws_autoscaling_group.asg.name

}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "scale-down-alarm"
  alarm_description   = "Scale Down Alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "2"
  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.asg.name}"
  }
  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.scale_down_policy.arn}"]
}

resource "aws_autoscaling_attachment" "asg_lb_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn    = aws_lb_target_group.alb_tg.arn
}

