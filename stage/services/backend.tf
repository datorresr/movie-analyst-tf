resource "aws_launch_template" "MoviesBackEndTemplate" {
  name = "MoviesBackEndTemplate"

  iam_instance_profile {
    name = "MySessionManagerRole"
  }

  image_id = "ami-0f3181dd152afed2c"
  instance_type = "t2.micro"
  key_name = "devopsrampup"

  vpc_security_group_ids = ["${data.terraform_remote_state.net.SG_BE_EC2_id}"]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "MoviesBackEnd"
    }
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
              echo 'DB_HOST="${data.terraform_remote_state.db.outputs.moviesDB_address}"' >> /etc/environment
              echo 'DB_USER="${data.terraform_remote_state.db.outputs.moviesDB_username}"' >> /etc/environment
              echo 'DB_PASS="${data.terraform_remote_state.db.outputs.moviesDB_password}"' >> /etc/environment
              cd /home/ec2-user/movie-analyst-api
              su ec2-user -c 'git pull origin master'
              systemctl restart moviesback
              systemctl status moviesback
              EOF
              )
}


resource "aws_autoscaling_group" "MoviesBackEndAS" {
  name                      = "MoviesBackEndAS"
  max_size                  = 4
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300


  force_delete = true

  vpc_zone_identifier = [data.terraform_remote_state.net.outputs.subnet_PriBE1_id, data.terraform_remote_state.net.outputs.subnet_PriBE2_id]


  target_group_arns = [aws_lb_target_group.BE-LB-TG.arn]

  launch_template {
    id      = aws_launch_template.MoviesBackEndTemplate.id
    version = "$Latest"
  }

}


resource "aws_lb" "MoviesLBBackEnd" {

  name               = "MoviesLBBackEnd"
  internal           = true
  load_balancer_type = "application"
  subnets            = [data.terraform_remote_state.net.outputs.subnet_PriBE1_id, data.terraform_remote_state.net.outputs.subnet_PriBE2_id]
  security_groups    = [data.terraform_remote_state.net.outputs.SG_LB_INT_BE_id]
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

resource "aws_lb_target_group" "BE-LB-TG" {

  name = "BE-LB-TG"

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
  listener_arn = aws_lb_listener.BE_Listener.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.BE-LB-TG.arn
  }
}