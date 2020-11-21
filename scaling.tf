resource "aws_autoscaling_group" "scale_group" {
  name                = "scale_group"
  min_size            = 1
  max_size            = 4
  desired_capacity    = 1
  vpc_zone_identifier = [aws_subnet.s1.id, aws_subnet.s2.id]

  target_group_arns = [aws_lb_target_group.tg.id]

  tag {
    key                 = "Name"
    value               = "POC"
    propagate_at_launch = true
  }

  termination_policies = ["OldestInstance"]

  mixed_instances_policy {
    instances_distribution {
      spot_allocation_strategy = "lowest-price"
      spot_instance_pools      = "2"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.template.id
        version            = "$Latest"
      }
    }
  }
}

resource "aws_launch_template" "template" {
  name_prefix   = "template"
  image_id      = "ami-0885b1f6bd170450c"
  instance_type = "t2.micro"
  key_name      = var.key_name

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.sg.id]
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 20
    }
  }
}

resource "aws_autoscaling_policy" "policy_up" {
  name                   = "scaling_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.scale_group.name
}

resource "aws_autoscaling_policy" "policy_down" {
  name                   = "scaling_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.scale_group.name
}