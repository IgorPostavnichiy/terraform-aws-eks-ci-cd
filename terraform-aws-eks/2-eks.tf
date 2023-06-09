module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  cluster_name = "igor-cluster-eks"
  cluster_version = "1.23"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  create_kms_key            = false
  eks_managed_node_groups = {
  main = {
      min_size     = 2
      max_size     = 10
      desired_size = 2

    instance_type = "t3.medium"
    capacity_type = "SPOT"
    }
  }
  cluster_encryption_config = {}  
  
}

resource "aws_route53_zone" "dns" {
  name     = "it-sproutdevteam.fun"
}

resource "aws_launch_configuration" "example-eks-node" {
  name_prefix             = "example-eks-node"
  image_id                = "ami-09bd96b2e49b45f16"
  instance_type           = "t2.micro"
}
