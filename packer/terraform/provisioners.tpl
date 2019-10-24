{
  "type": "ansible",
  "playbook_file": "playbook-${lower(kind)}.yaml",
  "groups": ["${lower(kind)}"],
  "only": ["${kind}"],
  "ansible_env_vars": ["ANSIBLE_REMOTE_USER=ubuntu"]
}
