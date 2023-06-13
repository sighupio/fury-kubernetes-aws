/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

output "ebs_csi_driver_iam_role_arn" {
  description = "ebs-csi-driver IAM role"
  value       = module.aws_ebs_csi_driver_iam_assumable_role.this_iam_role_arn
}
