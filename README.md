# ansible-dev

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/ymmmtym/ansible-dev)

## Requirements
- python >= 3

### Install python3 for Mac
If your mac is not installed python3.X, execute follow procedure.

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install python
echo "export PATH=/usr/local/bin:$PATH" > ~/.bash_profile
source ~/.bash_profile
```

## Usage
activate ansible env

```
git clone git@github.com:ymmmtym/ansible-dev.git
cd ansible-dev
. .ansiblevenv/bin/activate
```

Initialize env

```
python3 -m venv --clear .ansiblevenv
. .ansiblevenv/bin/activate
pip install -r requirements.txt
```

modify secret.yml for gitconfig

```
git_user_name=<put your git user name>
git_user_email=<put your git user email>

cat <<EOF > roles/commom/vars/secret.yml
gitconfig_secret:
  - { name: "user.name", value: "${git_user_name}"}
  - { name: "user.email", value: "${git_user_email}"}
EOF

ansible-vault encrypt roles/commom/vars/secret.yml
echo '<put vault password>' > ~/.vault_password
```

### Setup any hosts
Setup mac

```
ansible-playbook setup_local_mac.yml
```

Common Setup any linux hosts

```
ansible-playbook common.yml
```
