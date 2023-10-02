resource "aws_launch_template" "MoviesBackEndTemplate" {
  name = "MoviesBackEndTemplate"

  iam_instance_profile {
    name = "arn:aws:iam::700029235138:instance-profile/MySessionManagerRole"
  }

  image_id = "ami-00e985a026a8707df"
  instance_type = "t2.micro"
  key_name = "devopsrampup"

  network_interfaces {
    associate_public_ip_address = false
  }

  vpc_security_group_ids = ["${aws_security_group.SG_BE_EC2.id}"]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "MoviesBackEnd"
    }
  }

  user_data = <<-EOF
              #!/bin/bash
              exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
              cd /home/ec2-user/movie-analyst-api
              su ec2-user -c 'git pull origin master'
              systemctl restart moviesback
              systemctl status moviesback
              EOF
}


resource "aws_autoscaling_group" "MoviesBackEndAS" {
  name                      = "MoviesBackEndAS"
  max_size                  = 4
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300


  force_delete = true

  vpc_zone_identifier = [aws_subnet.PriBE1.id, aws_subnet.PriBE2.id]


  target_group_arns = [aws_lb_target_group.BE_LB_TG.arn]

  launch_template {
    id      = aws_launch_template.MoviesBackEndTemplate.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}


resource "aws_lb" "MoviesLBBackEnd" {

  name               = "MoviesLBBackEnd"

  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.SG_LB_INT_BE.id]
}

resource "aws_lb_listener" "BE_Listener" {
  load_balancer_arn = aws_lb.MoviesLBBackEnd.arn
  port              = 3000
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "BE_LB_TG" {

  name = "BE_LB_TG"

  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.VPCDevOpsRampUp

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.BE_LB_TG.arn
  }
}