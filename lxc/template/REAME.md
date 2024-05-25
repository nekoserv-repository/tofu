# how to use
rm -rf plan .terraform* terraform.tf*
terraform init
ansible-playbook -e @secrets.enc --ask-vault-pass ansible.yaml

## how to upgrade
sed -i -e "s/3.19/3.20/g" /etc/apk/repositories
apk update
apk upgrade -i -a --update-cache
#update-conf -a -l
update-conf -a
apk del --purge doas
apk del --purge openssh; apk add --no-cache openssh-server
sync
rc-service sshd restart
rm -rf ~/.ash_history ~/.ssh/ /var/cache/apk/* /tmp/* /var/log/* /var/tmp/*
^D

# proxmox gui
click on alpine-template container
go to backup, backup now and backup-it (default settings are fine)

# proxmox ssh
ssh user@your-proxmox-instance.domain
cp /var/lib/vz/dump/vzdump-lxc-*.zst /var/lib/vz/template/cache/alpine-3.20.0.tar.zst;
rm /var/lib/vz/dump/vzdump-lxc-*

# stuff
remove container: terraform destroy --auto-approve;
update your terraform : change template_name in vars.tf
