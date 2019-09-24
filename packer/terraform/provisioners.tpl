{
  "type": "ansible",
  "playbook_file": "playbook-${lower(kind)}.yaml",
  "only": ["${kind}"]
}
