provider "aws" {
   region = "af-south-1"
}

variable vpc_cidr_block {}
variable private_subnet_cidr_blocks {}
variable  public_subnet_cidr_blocks {}

data "aws_avaailability_zones" "azs" {}

module "foxappvpc" {
   source = "terraform-aws-modules/vpc/aws"
   version = "2.64.0"

   name = "Foxapp-vpc"
   cidr = var.vpc_cidr_block
   private_subnets = var.private_subnet_cidr_blocks
   public_subnets = var.public_subnet_cidr_blocks
   azs = data.aws_availability_zones.azs.names

   enable_net_gateway = true
   single_nat_gateway = true
   enable_dns_gateway = true

   tags = {
       "kubernetes.io/cluster/foxapp-eks-cluster" = "shared"
   }

   public_subnets_tags = {
       "kubernetes.io/cluster/foxapp-eks-cluster" = "shared"
       "kubernetes.io/role/elb" = 1
   }
    private_subnets_tags = {
       "kubernetes.io/cluster/foxapp-eks-cluster" = "shared"
       "kubernetes.io/role/internal-elb" = 1
    }
}