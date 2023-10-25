output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "frontend_service_ip" {
  description = "Frontend load balancer IP"
  //value = kubernetes_service.frontend_service.status[0].load_balancer.ingress[0].ip
  value = "${kubernetes_service.frontend_service_ip}"
}