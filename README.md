# ansible-mgmt

[![Codacy Badge](https://app.codacy.com/project/badge/Grade/3fd9480b4f45452e9ffedfa32e980e5b)](https://www.codacy.com/gh/ymmmtym/ansible-mgmt/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=ymmmtym/ansible-mgmt&amp;utm_campaign=Badge_Grade)
![Ansible](https://github.com/ymmmtym/ansible-mgmt/workflows/Ansible/badge.svg?event=pull_request)

This is my home environment.

## Requirements

- ESXi      >= 7.0
- python    >= 3.6
- packer    >= 1.7.2
- terraform >= 0.15.4
- ansible   >= 2.10.9

## Usage

### Preparetion

Clone this repository

```bash
git clone git@github.com:ymmmtym/ansible-mgmt.git
cd ansible-mgmt
```

Set environment vars like `.sample.env`

```bash
cp .sample.env .env

# fix .env for your environment
vi .env

# after fix .env
. .env
```

Decrypt encrypted files(by searching following command) by ansible-vault

```bash
grep -r "ANSIBLE_VAULT" inventories/*
```

Then, fix `group_vars` and `host_vars` by your environment

### Create Template VMs by Packer

exec following command at current direcroty

```bash
packer build packer/templates.json -var-file=packer/variables.json
```

If you want more template images, you need to add template config to `packer/templates.json`

### Setup any hosts

Activate ansible environment

ex)

```bash
python3 -m venv --clear .venv
. .venv/bin/activate
pip install -r requirements.txt
```

Setup all

```shell
ansible-playbook site.yml
```
