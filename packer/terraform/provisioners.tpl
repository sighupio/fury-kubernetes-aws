{
  "type": "ansible",
  "playbook_file": "playbook-${lower(kind)}.yaml",
  "groups": ["${lower(kind)}"],
  "only": ["${kind}"],
  "ansible_env_vars": ["ANSIBLE_REMOTE_USER=ubuntu"],
  "extra_arguments" : [
    "--extra-vars", "kubelet_version=${kube-version} kubectl_version=${kube-version} kubeadm_version=${kube-version} critools_version=${cri-tools-version}"
  ]
}
