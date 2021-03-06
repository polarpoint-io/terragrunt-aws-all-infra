terraform {
  backend "s3" {
  }
}

provider "aws" {
  region  = var.aws["region"]
  version = "2.63.0"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

provider "helm" {
  install_tiller                  = true
  service_account                 = "tiller"
  tiller_image                    = "gcr.io/kubernetes-helm/tiller:v2.16.1"
  automount_service_account_token = true

  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    load_config_file       = false
  }
}

data "aws_availability_zones" "available" {
}

data "aws_caller_identity" "current" {
}

data "aws_eks_cluster" "cluster" {
  name = var.eks["cluster_name"]
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.eks["cluster_name"]
}
