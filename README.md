# ansible-mgmt
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/63c0a38a6d20423f902974bcd9f7dc9c)](https://app.codacy.com/manual/ymmmtym/ansible-mgmt?utm_source=github.com&utm_medium=referral&utm_content=ymmmtym/ansible-mgmt&utm_campaign=Badge_Grade_Dashboard)
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/ymmmtym/ansible-mgmt)

## Requirements
-  python >= 3

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

modify secret.yml for gitconfig

```shell
git_user_name=<put your git user name>
git_user_email=<put your git user email>

eval "cat <<< \"$(cat gitconfig_secret.template.yml)\"" >> roles/dev/vars/secret.yml

# if you need to encrypt secret
ansible-vault encrypt roles/dev/vars/secret.yml
echo '<put vault password>' > .vault_password
```

### Setup any hosts
Setup all

```shell
ansible-playbook site.yml
```