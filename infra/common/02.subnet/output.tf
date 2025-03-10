
output "subnet_ids" {
  value = {
    public  = [for k, v in aws_subnet.subnets : v.id if startswith(k, "public")]
    private = [for k, v in aws_subnet.subnets : v.id if startswith(k, "private")]
  }
}