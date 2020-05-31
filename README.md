# ansible-mgmt

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/49ff5492f45c4112b435d23331264847)](https://app.codacy.com/manual/ymmmtym/ansible-mgmt?utm_source=github.com&utm_medium=referral&utm_content=ymmmtym/ansible-mgmt&utm_campaign=Badge_Grade_Dashboard)
![Ansible](https://github.com/ymmmtym/ansible-mgmt/workflows/Ansible/badge.svg)

## Requirements

- python >= 3.6

### Install python3 for Mac

If your mac is not installed python3.X, execute follow procedure.

```shell
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install python
echo "export PATH=/usr/local/bin:$PATH" > ~/.bash_profile
source ~/.bash_profile
```

## Usage

activate ansible env

```shell
git clone git@github.com:ymmmtym/ansible-mgmt.git
cd ansible-mgmt
python3 -m venv --clear .venv
. .venv/bin/activate
pip install -r requirements.txt
```

### Setup any hosts

Setup all

```shell
ansible-playbook site.yml
```
