provider "aws" {
  region = "ap-south-1" 
}

resource "aws_launch_template" "example" {
  name          = "standbypool-launch-template"
  image_id      = "ami-0ceb902fa839778f0" # "ami-062f0cc54dbfd8ef1" // Replace with a valid AMI ID
  instance_type = "t3.micro"
  key_name      = "hoad"   
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.standby_pool_sg.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "standby-node"
    }
  }
  hibernation_options {
    configured = true
  }
}

resource "aws_security_group" "standby_pool_sg" {
  name        = "standby-pool-sg"
  description = "Security group for standby pool instances"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (adjust as needed)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

# manage the standby pool of instances

resource "aws_instance" "standby_pool" {
  count = 1 // Number of stopped instances in the pool
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "standby-node-${count.index}"
  }
  hibernation = true
  root_block_device {
    volume_size = 8  # Replace with desired root volume size
    volume_type = "gp3"  # Replace with desired volume type
    encrypted = true
    #kms_key_id = "arn:aws:kms:region:account_id:key/your-key-id" # Optional: Specify your KMS key
  }
  # Start instances in stopped state
  # instance_initiated_shutdown_behavior = "stop"
}



