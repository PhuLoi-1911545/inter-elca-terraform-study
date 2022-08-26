provider "aws" {
    region = "ap-southeast-2"
    access_key = "AKIATLSF73HKN25FQGFU"
    secret_key = "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"
  
}

locals {
  zone = ["ap-southeast-2a", "ap-southeast-2b"]
  public = ["10.0.1.0/24", "10.0.2.0/24"]
  private = ["10.0.3.0/24", "10.0.4.0/24"]
}


resource "aws_vpc" "terraform_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true

    tags = {
      "Name" = "terraform-vpc-testing"
    }
  
}

# resource "aws_subnet" "terraform_public_subnet" {
#     vpc_id = aws_vpc.terraform_vpc.id
#     cidr_block = "10.0.1.0/24"
#     availability_zone = "ap-southeast-2a"

#     tags = {
#       "Name" = "terraform-public-subnet"
#     }
  
# }

# resource "aws_subnet" "terraform_private_subnet" {
#     vpc_id = aws_vpc.terraform_vpc
#     cidr_block = "10.0.2.0/24"
#     availability_zone = "ap-southeast-2b"

#     tags = {
#       "Name" = "terraform-private-subnet"
#     }
  
# }

resource "aws_subnet" "terraform_public_subnet" {
    count = length(local.public)
    
    vpc_id = aws_vpc.terraform_vpc.id
    cidr_block = local.public[count.index]
    availability_zone = local.zone[count.index % length(local.zone)]

    tags = {
      "Name" = "terraform_public_subnet_testing"
    }

}

resource "aws_subnet" "terraform_private_subnet" {
    count = length(local.private)

    vpc_id = aws_vpc.terraform_vpc.id
    cidr_block = local.private[count.index]
    availability_zone = local.zone[count.index % length(local.zone)]
    
    tags = {
      "Name" = "terraform_private_subnet_testing"
    }
  
}

resource "aws_internet_gateway" "terraform_gateway" {
    vpc_id = aws_vpc.terraform_vpc.id

    tags = {
      "Name" = "terraform_gateway_testing"
    }
  
}

resource "aws_route_table" "terraform_public_route_table" {
    vpc_id = aws_vpc.terraform_vpc.id

    route  {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.terraform_gateway.id
    } 
    

    tags = {
      "Name" = "terraform_public_route_table_testing"
    }
}

resource "aws_route_table_association" "terraform_public_route_table_association" {
    for_each = {for k, v in aws_subnet.terraform_public_subnet: k => v}
    subnet_id = each.value.id
    route_table_id = aws_route_table.terraform_public_route_table.id
  
}

# resource "aws_eip" "nat" {
#     vpc = true
  
# }

# resource "aws_nat_gateway" "public" {
#     depends_on = [
#       [aws_internet_gateway.terraform_gateway]
#     ]
#     allocation_id = aws_eip.nat.id
#     subnet_id = aws_subnet.terraform_public_subnet[0].id

#     tags = {
#       "Name" = "terraform_public_nat"
#     }
  
# }

# resource "aws_route_table" "terraform_private_route_table" {
#     vpc_id = aws_vpc.terraform_vpc.id
    
    
#     route  {
#       # cidr_block = "0.0.0.0/0"
#       gateway_id = aws_vpc.terraform_vpc.id

#       # gateway_id = "aws_nat_gateway.public.id"
#     } 

#     tags = {
#       "Name" = "terraform_private_route_table_testing"
#     }
# }

# resource "aws_route_table_association" "terraform_private_route_table_association" {
#     for_each = {for k, v in aws_subnet.terraform_private_subnet: k => v}
#     subnet_id = each.value.id
#     route_table_id = aws_route_table.terraform_private_route_table.id
  
# }

# resource "aws_main_route_table_association" "terraform_main_route_table_association" {
#     vpc_id = aws_vpc.terraform_vpc.id
#     route_table_id = aws_route_table.terraform_private_route_table.id
    
  
# }

