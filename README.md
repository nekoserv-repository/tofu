![terraform](https://repository-images.githubusercontent.com/676958218/4bd582ad-9a7a-49fb-bfcd-d1b3c3a9481a)

<br />

How to use :

- install :
  - wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  - echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  - sudo apt update && sudo apt install terraform

- clone : git clone https://github.com/nekoserv-repository/terraform.git

- update vault : ansible-vault edit secrets.enc

- run examples :
  - ansible-playbook -e @secrets.enc --ask-vault-pass ansible.yaml
