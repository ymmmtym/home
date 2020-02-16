#! /bin/bash

export json=$(curl -u ymmmtym: -ks "https://api.github.com/users/ymmmtym/repos")
export count=$(($(echo "${json}" | jq '. | length') - 1))

echo "Follow repos are found"
echo "${json}" | jq '.[].name'

for i in $(seq 0 ${count})
do
  ssh_url=$(echo "${json}" | jq -r .[${i}].ssh_url)
  name=$(echo "${json}" | jq -r .[${i}].name)
  echo -n "clone ${name} ? (y/n): "
  read input
  if [ $input = "y" ]; then
    git clone $ssh_url
  elif [ $input = "n" ]; then
    continue
  else
    echo "Please input (y or n)"
    exit 1
  fi
done

echo "Done!"
exit 0