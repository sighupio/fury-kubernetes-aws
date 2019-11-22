{
  "variables": {
    "aws_access_key": "{{env `AWS_ACCESS_KEY_ID`}}",
    "aws_secret_key": "{{env `AWS_SECRET_ACCESS_KEY`}}"
  },
  "builders": [
    ${builders}
  ],
  "provisioners": [
    ${provisioners}, {
      "type": "shell",
      "inline": [
        "rm /home/${user}/.ssh/authorized_keys"
      ]
    }

  ]
}
