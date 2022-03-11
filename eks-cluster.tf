provider "kubernetes" {
   load_config_file = "false"
   host =  data.aws_eks_cluster.foxapp-cluster.endpoint
   token = data.aws_eks_cluster_auth.foxapp-cluster.token
   cluster_ca_certificate = base64decode(data.aws_eks_cluster.foxapp-cluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "foxapp-cluster" {
    name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "foxapp-cluster" {
    name = module.eks.cluster_id
}

module "eks" {
   source = "terraform-aws-module/eks/aws"
   version = "13.2.1"

   cluster_name = "foxapp-eks-cluster"
   cluster_version = "1.17"

   subnets = module.foxapp-vpc.private_subnets
   vpc_id = module.foxapp-vpc.vpc_id

   tags = {
       environment = "development"
       application = "foxapp"
   }

   worker_groups = [
       {
           instance_type = "t2.small"
           name = "worker-group-1"
           asg_desired_capacity = 2
       },
       {
           instance_type = "t2.smedium"
           name = "worker-group-2"
           asg_desired_capacity = 1
       }
   ]
}