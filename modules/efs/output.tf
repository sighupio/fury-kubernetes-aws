locals {
  efs-configmap = <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: efs-provisioner
data:
  file.system.id: ${aws_efs_file_system.efs.id}
  aws.region: ${var.region}
  provisioner.name: sighup.io/aws-efs
  dns.name: "${aws_efs_file_system.efs.dns_name}"
EOF

  efs-deployment-kustomize= <<EOF
kind: Deployment
apiVersion: apps/v1
metadata:
  name: efs-provisioner
spec:
  template:
    spec:
      volumes:
        - name: pv-volume
          nfs:
            server: ${aws_efs_file_system.efs.dns_name}
            path: /
EOF

}

output "efs-configmap" {
  value = "${local.efs-configmap}"
}


output "efs-deployment-kustomize" {
  value = "${local.efs-deployment-kustomize}"
}