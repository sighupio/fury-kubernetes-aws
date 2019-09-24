output:
	cd terraform && terraform output amis > ../ami.json

amis:
	packer build ami.json
