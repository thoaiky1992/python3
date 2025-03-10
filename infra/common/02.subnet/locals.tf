
/*
  CIDR /24 cung cấp 256 địa chỉ IP, nhưng AWS dành trước 5 địa chỉ (0, 1, 2, 3, 255),
  nên thực tế có 251 địa chỉ khả dụng cho tài nguyên (EC2, Load Balancer, etc.).
*/

locals {
  public_subnets = [
    for i, v in data.aws_availability_zones.azs.names : {
      name                    = "public-subnet-${i + 1}",
      cidr_block              = cidrsubnet(var.vpc_cidr, 8, i + 1),
      availability_zone       = v,
      map_public_ip_on_launch = true
    }
  ]
  private_subnets = [
    for i, v in data.aws_availability_zones.azs.names : {
      name                    = "private-subnet-${i + 1}",
      cidr_block              = cidrsubnet(var.vpc_cidr, 8, length(data.aws_availability_zones.azs.names) + i + 1),
      availability_zone       = v,
      map_public_ip_on_launch = true
    }
  ]
}
