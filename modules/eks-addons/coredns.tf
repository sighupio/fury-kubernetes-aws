resource "aws_eks_addon" "coredns" {
  cluster_name      = var.cluster_name
  addon_name        = "coredns"
  addon_version     = var.coredns.version
  resolve_conflicts = var.coredns.resolve_conflicts
  tags              = var.tags
  count             = var.coredns.enabled ? 1 : 0
}
