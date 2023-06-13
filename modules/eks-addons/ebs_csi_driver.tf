module "iam_for_ebs_csi_driver" {
  source       = "../iam-for-ebs-csi-driver"
  cluster_name = var.cluster_name
  count        = var.ebs_csi_driver.enabled ? 1 : 0
}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = var.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = var.ebs_csi_driver.version
  resolve_conflicts        = var.ebs_csi_driver.resolve_conflicts
  service_account_role_arn = module.iam_for_ebs_csi_driver[0].ebs_csi_driver_iam_role_arn
  tags                     = var.tags
  count                    = var.ebs_csi_driver.enabled ? 1 : 0
}
