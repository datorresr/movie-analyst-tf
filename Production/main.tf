provider "kubernetes" {
  //config_path = "~/.kube/config"
  //load_config_file       = false
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  //cluster_ca_certificate = "${base64decode(aws_eks_cluster.my_cluster.certificate_authority.0.data)}"
  token                  = "${data.aws_eks_cluster_auth.cluster_auth.token}"
}

provider "aws" {
  alias  = "peer"
  region = var.region
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

resource "kubernetes_config_map" "aws_auth_configmap" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data {
    mapRoles = <<YAML
  - rolearn: ${module.eks.eks_managed_node_groups}
    username: system:node:{{EC2PrivateDNSName}}
    groups:
      - system:bootstrappers
      - system:nodes
  - rolearn: ${module.eks.cluster_iam_role_arn}
    username: kubectl-access-user
    groups:
      - system:masters
  YAML
    }
}