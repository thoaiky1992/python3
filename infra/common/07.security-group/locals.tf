locals {
  security_groups = [
    {
      name = "bastion-host-security-group"
      ingress = [
        { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
        { from_port = 8080, to_port = 8080, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
      ]
      egress = [{ from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }]
    },
    {
      name    = "postgres-security-group"
      ingress = [{ from_port = 5432, to_port = 5432, protocol = "tcp", cidr_blocks = ["10.0.0.0/16"] }]
      egress  = [{ from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }]
    },
    {
      name    = "pgbouncer-security-group"
      ingress = [{ from_port = 6432, to_port = 6432, protocol = "tcp", cidr_blocks = ["10.0.0.0/16"] }]
      egress  = [{ from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }]
    },
    {
      name = "api-security-group"
      ingress = [
        { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["10.0.0.0/16"] },
        { from_port = 4000, to_port = 4000, protocol = "tcp", cidr_blocks = ["10.0.0.0/16"] },
        { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["10.0.0.0/16"] },
        { from_port = 30000, to_port = 65535, protocol = "tcp", cidr_blocks = ["10.0.0.0/16"] }
      ]
      egress = [{ from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }]
    },
    {
      name = "ui-security-group"
      ingress = [
        { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
        { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
        { from_port = 3000, to_port = 3000, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
        { from_port = 30000, to_port = 65535, protocol = "tcp", cidr_blocks = ["10.0.0.0/16"] },
        { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["10.0.0.0/16"] },
      ]
      egress = [{ from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }]
    },
    {
      name    = "default-security-group"
      ingress = [{ from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }]
      egress  = [{ from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }]
    }
  ]
}
