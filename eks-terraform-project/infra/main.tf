# ============================================
# ROOT MODULE
# Calls: VPC, EKS, Node Groups modules
# Author: Jyotsna Sree Varshita Rajana
# Certification: HashiCorp Certified Terraform Associate (004)
# ============================================

# ============================================
# VPC MODULE
# ============================================
module "vpc" {
  source               = "./modules/vpc"
  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availabilty_zones    = var.availability_zones

}

# ============================================
# EKS MODULE
# ============================================
module "eks" {
  source             = "./modules/eks"
  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  cluster_version    = var.cluster_version

  depends_on = [module.vpc]
}

# ============================================
# NODE GROUPS MODULE
# ============================================
module "node_group" {
  source             = "./modules/node-groups"
  project_name       = var.project_name
  environment        = var.environment
  cluster_name       = module.eks.cluster_name
  private_subnet_ids = module.vpc.private_subnet_ids
  node_desired_size  = var.node_desired_size
  node_instance_type = var.node_instance_type
  node_max_size      = var.node_max_size
  node_min_size      = var.node_min_size

  depends_on = [module.eks]
}