resource "aws_launch_template" "MoviesFrontEndTemplate" {
  name = "MoviesFrontEndTemplate"

  iam_instance_profile {
    name = "MySessionManagerRole"
  }

  image_id = "ami-0a08905e1b9d0937c"
  instance_type = "t2.micro"
  key_name = "devopsrampup"

  vpc_security_group_ids = ["${aws_security_group.SG_FE_EC2.id}"]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "MoviesFrontEnd"
    }
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
              su ec2-user -c ´echo 'export BACK_LB="${aws_lb.MoviesLBBackEnd.dns_name}"' >> /etc/environment´
              cd /home/ec2-user/movie-analyst-ui
              su ec2-user -c 'git pull origin master'
              systemctl restart movies
              systemctl status movies
              EOF
              )
}


resource "aws_autoscaling_group" "MoviesFrontEndAS" {
  name                      = "MoviesFrontEndAS"
  max_size                  = 4
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300


  force_delete = true

  vpc_zone_identifier = [aws_subnet.PriFE1.id, aws_subnet.PriFE2.id]


  target_group_arns = [aws_lb_target_group.FE-LB-TG.arn]

  launch_template {
    id      = aws_launch_template.MoviesFrontEndTemplate.id
    version = "$Latest"
  }

}


resource "aws_lb" "MoviesLBFrontEnd" {

  name               = "MoviesLBFrontEnd"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.PubLB1.id, aws_subnet.PubLB2.id]
  security_groups    = [aws_security_group.SG_LB_EXT_FE.id]
}

resource "aws_lb_listener" "FE_Listener" {
  load_balancer_arn = aws_lb.MoviesLBFrontEnd.arn
  port              = 80
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

resource "aws_lb_target_group" "FE-LB-TG" {

  name = "FE-LB-TG"

  port     = 3030
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

resource "aws_lb_listener_rule" "asgfe" {
  listener_arn = aws_lb_listener.FE_Listener.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.FE-LB-TG.arn
  }
}