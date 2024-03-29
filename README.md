# home

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/3fd9480b4f45452e9ffedfa32e980e5b)](https://www.codacy.com/gh/ymmmtym/home/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=ymmmtym/home&amp;utm_campaign=Badge_Grade)
[![Ansible Lint](https://github.com/ymmmtym/home/actions/workflows/ansible.yml/badge.svg)](https://github.com/ymmmtym/home/actions/workflows/ansible.yml)
[![Packer](https://github.com/ymmmtym/home/actions/workflows/packer.yml/badge.svg)](https://github.com/ymmmtym/home/actions/workflows/packer.yml)
[![VyOS Rolling Update Notify](https://github.com/ymmmtym/home/actions/workflows/vyos-rolling-update-notify.yml/badge.svg)](https://github.com/ymmmtym/home/actions/workflows/vyos-rolling-update-notify.yml)

This is my home environment.

## Diagram

### Network

![home](./img/home.dio.svg)

## Requirements

| Software        | Version | Description |
| --------------- | ------- | ----------- |
| ESXi            | >= 7.0  |             |
| VMware Ovf Tool | >= 4.3  |             |
| python          | >= 3.7  |             |
| packer          | >= 1.7  |             |
| terraform       | >= 0.15 |             |
| ansible         | >= 3.3  |             |
| rke             | >= 1.2  |             |
| vagrant         | >= 2.2  | Optional    |

## Usage

### Preparation

#### ESXi

- Enable Access to the ESXi Shell via SSH.
  - [How to Enable SSH in the VMware ESXi Embedded Host Client](https://blog.macstadium.com/blog/how-to-enable-ssh-in-the-vmware-esxi-embedded-host-client)
- Enable GuestIPHack.
  - `esxcli system settings advanced set -o /Net/GuestIPHack -i 1`

#### Clone this repository

```bash
git clone git@github.com:ymmmtym/home.git
cd home
```

#### Set environment vars like `.sample.env`

create `.env` for your environment.
and source `.env`

```bash
cp .sample.env .env
vi .env
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

#### Exec terraform apply

Activate ansible environment.

ex)

```bash
python3 -m venv --clear .venv
. .venv/bin/activate
pip install -r requirements.txt
```

Add route to public network.

```bash
ip r add 192.168.100.0/24 via 192.168.0.4
```

Exec terraform apply.

```bash
cd terraform
terraform apply
```
