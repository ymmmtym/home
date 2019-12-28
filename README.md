# ansible-dev

## Requirements

- python >= 3

### Install python for Mac

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

### Setup mac for developer

modify secret.yml for gitconfig

```
git_user_name=<Input your git user name>
git_user_email=<Input your git user email>

cat <<EOF > roles/commom/vars/secret.yml
gitconfig_secret:
  - { name: "user.name", value: "${git_user_name}"}
  - { name: "user.email", value: "${git_user_email}"}
EOF

ansible-playbook setup_mac.yml
```
