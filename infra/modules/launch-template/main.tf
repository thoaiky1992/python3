resource "aws_launch_template" "ecs_db_launch_template" {
  name          = "${var.tag_version}-ecs-db-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  iam_instance_profile {
    name = var.ecs_instance_role_profile_name
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 30
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  block_device_mappings {
    device_name = "/dev/xvdf" # Ổ đĩa phụ dùng cho PostgreSQL
    ebs {
      volume_size           = 50 # 100GB EBS volume riêng
      volume_type           = "gp3"
      delete_on_termination = false # Giữ lại EBS ngay cả khi EC2 bị xóa

    }
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.tag_version}-ecs-db-instance"
    }
  }

  network_interfaces {
    associate_public_ip_address = false                                                # Ensure this is false for private subnet
    subnet_id                   = var.private_subnet_ids[1]                           # Replace with your private subnet ID
    security_groups             = [var.security_groups["postgres-security-group"].id] # Replace with your security group ID
  }

  user_data = base64encode(templatefile("${path.module}/db-user-data.sh.tftpl", { ECS_CLUSTER_NAME = var.ecs_cluster.db.name }))
}

resource "aws_launch_template" "ecs_api_launch_template" {
  name          = "${var.tag_version}-ecs-api-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  iam_instance_profile {
    name = var.ecs_instance_role_profile_name
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 30
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.tag_version}-ecs-api-instance"
    }
  }

  network_interfaces {
    associate_public_ip_address = true                                               # Ensure this is false for private subnet
    subnet_id                   = var.public_subnet_ids[1]                           # Replace with your private subnet ID
    security_groups             = [var.security_groups["default-security-group"].id] # Replace with your security group ID
  }

  user_data = base64encode(templatefile("${path.module}/default-user-data.sh.tftpl", { ECS_CLUSTER_NAME = var.ecs_cluster.api.name }))
}
resource "aws_launch_template" "ecs_redis_launch_template" {
  name          = "${var.tag_version}-ecs-redis-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  iam_instance_profile {
    name = var.ecs_instance_role_profile_name
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 30
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.tag_version}-ecs-redis-instance"
    }
  }

  network_interfaces {
    associate_public_ip_address = false                                               # Ensure this is false for private subnet
    subnet_id                   = var.private_subnet_ids[1]                           # Replace with your private subnet ID
    security_groups             = [var.security_groups["redis-security-group"].id] # Replace with your security group ID
  }

  user_data = base64encode(templatefile("${path.module}/default-user-data.sh.tftpl", { ECS_CLUSTER_NAME = var.ecs_cluster.redis.name }))
}
