# Networking

## VPC

resource aws_vpc this {
  assign_generated_ipv6_cidr_block = false
  cidr_block                       = var.vpc_private_cidr
  enable_dns_hostnames             = true
  enable_dns_support               = true

  tags = merge(
    {
      Name = join(var.delimiter, [var.name, var.stage, "vpc", random_string.this.result])
      Tech = "VPC"
      Srv  = "VPC"
    },
    var.tags
  )
}

## Route Table <-> Subnet associations

resource aws_route_table_association private_0 {
  subnet_id      = aws_subnet.private_0.id
  route_table_id = aws_route_table.private_0.id
}

## Route Tables

resource aws_route_table private_0 {
  vpc_id = aws_vpc.this.id

  depends_on = [
    aws_vpc.this
  ]

  tags = merge(
    {
      Name = join(var.delimiter, [var.name, var.stage, "private-route", random_string.this.result])
      Tech = "Route"
      Srv  = "VPC"
    },
    var.tags
  )
}

## Subnets

resource aws_subnet private_0 {
  availability_zone               = var.availability_zone[0]
  vpc_id                          = aws_vpc.this.id
  cidr_block                      = var.vpc_private_cidr
  assign_ipv6_address_on_creation = false

  depends_on = [
    aws_vpc.this
  ]

  tags = merge(
    {
      Name = join(var.delimiter, [var.name, var.stage, "subnet-a", random_string.this.result])
      Tech = "Subnet"
      Srv  = "VPC"
      Note = "Private"
    },
    var.tags
  )
}

 
resource aws_security_group private_lambda_0 {
  description = "Private Lambda SG"
  name        = join(var.delimiter, [var.name, var.stage, "private-subnet-lambda-0", random_string.this.id])
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [
      var.vpc_private_cidr
    ]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [
      var.vpc_private_cidr
    ]
  }

  tags = merge(
    {
      Name = join(var.delimiter, [var.name, var.stage, "private-subnet-lambda-0", random_string.this.id])
      Tech = "Security Group"
      Srv  = "EC2"
    },
    var.tags
  )
}