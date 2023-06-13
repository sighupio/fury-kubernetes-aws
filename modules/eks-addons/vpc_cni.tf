resource "aws_eks_addon" "vpc_cni" {
  cluster_name      = var.cluster_name
  addon_name        = "vpc-cni"
  addon_version     = var.vpc_cni.version
  resolve_conflicts = var.vpc_cni.resolve_conflicts
  tags              = var.tags
  count             = var.vpc_cni.enabled ? 1 : 0
}
