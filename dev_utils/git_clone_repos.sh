#! /bin/bash

json=$(curl -u ymmmtym: -ks "https://api.github.com/users/ymmmtym/repos")
count=$(($(echo $json | jq '. | length') - 1))

echo "Follow repos are found"
echo $json | jq .[].name | nl
echo -n "clone repository number: "
read nums
for i in ${nums}; do
number=$((i - 1))
git clone $(echo $json | jq -r .[$number].ssh_url)
echo "Done!"
done
exit 0