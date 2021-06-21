# home

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/3fd9480b4f45452e9ffedfa32e980e5b)](https://www.codacy.com/gh/ymmmtym/home/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=ymmmtym/home&amp;utm_campaign=Badge_Grade)
![Ansible](https://github.com/ymmmtym/home/workflows/Ansible/badge.svg?event=pull_request)

This is my home environment.

![home](./img/home.dio.svg)

## Requirements

| software  | version |
| --------- | ------- |
| ESXi      | >= 7.0  |
| python    | >= 3.7  |
| packer    | >= 1.7  |
| terraform | >= 0.15 |
| ansible   | >= 3.3  |

## Usage

### Preparation

Preparation before create VMs.

#### Clone this repository

```bash
git clone git@github.com:ymmmtym/home.git
cd home
```

#### Set environment vars like `.sample.env`

```bash
cp .sample.env .env

# fix .env for your environment
vi .env

# after fix .env
. .env
```

#### Decrypt encrypted files(by searching following command) by ansible-vault

```bash
grep -r "ANSIBLE_VAULT" inventories/*
```

#### (Optional) Encrypt secret files by ansible-vault

```bash
echo "<your vault password>" > .vault_password
ansible-vault encrypt ${YOUR_SECRET_FILE_PATH}
```

#### Fix vars for your environment

##### Ansible

See `inventories` directory recursively.
Then, fix `inventories/base.yml` and `group_vars`, `host_vars` for your environment.

##### Terraform

Create `terraform/terraform.tfvars` like following text.

```terraform.tfvars
ESXI_HOSTNAME = "<IP Address of your ESXi>"
ESXI_USERNAME = "<Username for ESXi login>"
ESXI_PASSWORD = "<Password for ESXi login>"
```

##### Packer

Fix `packer/vairables.json` for your environment.

### Setup

#### Create Template VMs by Packer

Exec following command at current directory.

```bash
packer build packer/templates.json -var-file=packer/variables.json
```

If you want more template images, you need to add template config to `packer/templates.json`.

#### Setup any hosts

Activate ansible environment.

ex)

```bash
python3 -m venv --clear .venv
. .venv/bin/activate
pip install -r requirements.txt
```

Setup all hosts.

```shell
ansible-playbook site.yml
```
