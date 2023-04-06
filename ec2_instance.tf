variable "ami_name" {
  type = string
}

resource "aws_security_group" "ec2-security-group" {
  name_prefix = "my-security-group"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.load-balancer-security-group.id]
  }

  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = aws_vpc.kunal.id
  tags = {
    "Name" = "application"
  }
}




resource "aws_launch_template" "ec2-template" {

  name = "launch-template"

  image_id = var.ami_name # Replace with your desired AMI ID

  instance_type = "t2.micro" # Replace with your desired instance type

  key_name = "ec2" # Replace with your desired key pair

  # vpc_security_group_ids = [
  #   aws_security_group.ec2-security-group.id
  # ]

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [
      aws_security_group.ec2-security-group.id
    ]
  }



  iam_instance_profile {
    arn = aws_iam_instance_profile.webapp_s3_instance_profile.arn
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 8
      volume_type           = "gp2"
      delete_on_termination = true
    }
  }



    user_data = base64encode(<<-EOF
    #!/bin/bash
    cd /home/ec2-user/
    touch .env
    echo DATABASE_URL="mysql://${var.db_username}:${var.db_password}@${aws_db_instance.mydb.endpoint}" >> .env
    echo S3_Bucket_Name="${aws_s3_bucket.private_bucket.id}" >> .env
    echo APP_HOST="0.0.0.0" >> .env
    echo APP_PORT="5000" >> .env

    sudo systemctl daemon-reload
    sudo systemctl enable webapp
    sudo systemctl start webapp
    EOF
  )



  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Load balancer instance"
    }
  }
}