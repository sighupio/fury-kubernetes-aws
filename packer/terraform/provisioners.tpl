{
  "type": "ansible",
  "playbook_file": "playbook-${lower(kind)}.yaml",
  "groups": ["${lower(kind)}"],
  "only": ["${kind}"]
}
