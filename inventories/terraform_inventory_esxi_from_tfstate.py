#!/usr/bin/env python

import json


TERRAFORM_TFSTATE_PATH='./terraform/terraform.tfstate'

inventory = {'all': {'hosts': []}, '_meta': {'hostvars': {}}}
tfstate = json.load(open(TERRAFORM_TFSTATE_PATH, 'r'))
resources = tfstate['resources']

for resource in resources:
    if resource['type'] == 'esxi_guest':
        host = resource['name']
        inventory['all']['hosts'].append(host)
        inventory['_meta']['hostvars'][host] = resource['instances'][0]
        inventory['_meta']['hostvars'][host]['ansible_host'] \
            = resource['instances'][0]['attributes']['ip_address']


print(json.dumps(inventory, indent=4))
