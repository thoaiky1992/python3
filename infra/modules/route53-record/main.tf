data "aws_route53_zone" "aws_thoaiky_com" {
  name = var.domain_name
}
data "terraform_remote_state" "common" {
  backend = "s3"
  config = {
    bucket = "thoaiky-terraform-state"                      # Tên bucket đã tạo
    key    = "common/terraform.tfstate" # Đường dẫn key với biến version
    region = "ap-southeast-1"
  }
}
locals {
  upsert_route53_template = templatefile("${path.module}/upsert-route53.sh.tpl", {
    ROUTE_53_ZONE_ID = data.aws_route53_zone.aws_thoaiky_com.zone_id,
    DOMAIN_NAME      = var.domain_name,
    LB_ZONE_ID       = var.load_balancer_zone_id,
    LB_DNS_NAME      = var.load_balancer_dns_name,
  })
  bastion_host = {
    public_ip = data.terraform_remote_state.common.outputs.bastion_host.public_id
  }
}
resource "null_resource" "upsert_route53_record" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "remote-exec" {

    connection {
      type        = "ssh"
      host        = local.bastion_host.public_ip
      user        = "ubuntu"
      private_key = var.key_pair_pem
    }
    inline = [
      "echo '${local.upsert_route53_template}' > /tmp/upsert_route53.sh", # Write the rendered script to a file
      "chmod +x /tmp/upsert_route53.sh",                                  # Make sure the script is executable
      "/tmp/upsert_route53.sh"                                               # Execute the script,
    ]
  }
}
