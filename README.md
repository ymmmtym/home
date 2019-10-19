# ansible
## init
create python3 env
activate python3 env
install library

```
virtualenv -p python3.7 .ansible
source .ansible/bin/activate
pip install -r requirements.txt
```

## activate
activate python3 env
```
source .ansible/bin/activate
```

## update
update library
```
pip install ${library}
pip freeze > requirements.txt
```
`pip freeze`:installされているlibとver.を表示する

## operation
