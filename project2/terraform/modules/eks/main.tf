module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  name                 = "contrast-example"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }
}

module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name = var.cluster_name
  subnets      = module.vpc.public_subnets
  vpc_id       = module.vpc.vpc_id
  enable_irsa  = true

  worker_groups = [
    {
      name                 = "worker-group-1"
      instance_type        = "t2.medium"
      asg_desired_capacity = 1
    }
  ]
}
