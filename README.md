![tofu](https://repository-images.githubusercontent.com/805379847/8e9b052b-94e2-40c5-8def-9e46db826f2a)

<br/>
**How to use:**

- install OpenTofu: https://opentofu.org/docs/intro/install/
- OR fast install: sudo sh -c 'wget https://github.com/opentofu/opentofu/releases/download/v1.8.0/tofu_1.8.0_linux_amd64.tar.gz -O- | tar -C /usr/local/bin -zx tofu'

- clone: git clone https://github.com/nekoserv-repository/tofu.git

- edit secret vault: ansible-vault edit secrets.enc

- run examples:
  - tofu init
  - tofu destroy --auto-approve
  - tofu apply --auto-approve
