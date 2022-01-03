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
        for instance in resource['instances']:
            host = instance['attributes']['guest_name']
            INVENTORY['all']['hosts'].append(host)
            INVENTORY['_meta']['hostvars'][host] = instance
            INVENTORY['_meta']['hostvars'][host]['ansible_host'] \
                = instance['attributes']['ip_address']


print(json.dumps(INVENTORY, indent=4))
