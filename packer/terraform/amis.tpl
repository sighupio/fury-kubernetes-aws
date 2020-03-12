{
  "variables": {
    "aws_access_key": "{{env `AWS_ACCESS_KEY_ID`}}",
    "aws_secret_key": "{{env `AWS_SECRET_ACCESS_KEY`}}",
    "kube-version" : "${kube-version}",
    "critools_version" : "${critools_version}"
  },
  "builders": [
    ${builders}
  ],
  "provisioners": [
    {
      "type": "shell",
      "inline": [
        "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done"
      ]
    },
    ${provisioners}, {
      "type": "shell",
      "inline": [
        "rm /home/${user}/.ssh/authorized_keys"
      ]
    }

  ]
}
