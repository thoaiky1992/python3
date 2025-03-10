resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  user_data = templatefile("${path.module}/bastion-host.sh.tftpl", {})

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "${var.environment}-bastion-host"
  }
}
