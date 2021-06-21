#!/usr/bin/env python
# -*- coding: utf_8 -*-

"""Dynamic Inventory from terraform.tfstate for ESXi."""

import json


TERRAFORM_TFSTATE_PATH = './terraform/terraform.tfstate'
INVENTORY = {'all': {'hosts': []}, '_meta': {'hostvars': {}}}
TFSTATE = json.load(open(TERRAFORM_TFSTATE_PATH, 'r'))
RESOURCES = TFSTATE['resources']

for resource in RESOURCES:
    if resource['type'] == 'esxi_guest':
        host = resource['name']
        INVENTORY['all']['hosts'].append(host)
        INVENTORY['_meta']['hostvars'][host] = resource['instances'][0]
        INVENTORY['_meta']['hostvars'][host]['ansible_host'] \
            = resource['instances'][0]['attributes']['ip_address']


print(json.dumps(INVENTORY, indent=4))
