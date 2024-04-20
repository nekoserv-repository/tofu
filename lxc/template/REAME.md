# commands
rm -rf plan .terraform* terraform.tf*
terraform init
ansible-playbook -e @secrets.enc --ask-vault-pass ansible.yaml

# proxmox gui
click on alpine-template container
go to backup, backup now and backup-it (default settings are fine)

# proxmox ssh
ssh user@your-proxmox-instance.domain
cp /var/lib/vz/dump/vzdump-lxc-*.zst /var/lib/vz/template/cache/alpine-3.19.1.tar.zst;
rm /var/lib/vz/dump/vzdump-lxc-*

# stuff
remove container: terraform destroy --auto-approve;
update your terraform : change template_name in vars.tf
