# Terraform module for creating an Auto Scaling Group with a warm pool

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Auto Scaling Group"
  type        = list(string)
  default     = ["subnet-0aa64571", "subnet-5209d11e", "subnet-a4bad1cc"]
}

variable "ami" {
  description = "AMI ID for the instances"
  type        = string
  default = "ami-062f0cc54dbfd8ef1"
}

variable "instance_type" {
  description = "Instance type for the instances"
  type        = string
  default     = "t3.micro"
}

variable "warm_pool_size" {
  description = "Size of the warm pool"
  type        = number
  default     = 2
}

variable "warm_pool_state" {
  description = "State of the warm pool (Stopped or Running)"
  type        = string
  default     = "Stopped"
}

resource "aws_launch_template" "this" {
  name          = "my-launch-template"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name           = "hoad"   
  network_interfaces {
    associate_public_ip_address = true
  }
  #   warm pool cannot be spot !!!!!
}

resource "aws_autoscaling_group" "this" {
  name                      = "my-asg"
  max_size                  = var.warm_pool_size
  min_size                  = 0
  desired_capacity          = 1
  vpc_zone_identifier       = var.subnet_ids
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "my-asg-instance"
    propagate_at_launch = true
  }
  warm_pool {
    pool_state                  = var.warm_pool_state
    min_size                    = 1
    max_group_prepared_capacity = var.warm_pool_size

    instance_reuse_policy {
      reuse_on_scale_in = true
    }
  }
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.this.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}