#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
import sys
import logging
import requests
from requests.sessions import Session
logging.basicConfig(level=logging.INFO)

def getAADid(url:str,session:Session):
    target_uri = 'https://login.microsoftonline.com/' \
        + str(url) + '/.well-known/openid-configuration'
    with session.get(target_uri) as response:
        if response.status_code == 200:
            tenant_id = response.json()['issuer'].split('/')[3]
            return tenant_id
        logging.error('error: ' + str(response.status_code) \
            + ' failed to retrieve openid config for ' + str(domain))
        return None
if len(sys.argv) != 2:
    logging.error('usage: fetch.py <line-delim file of domains>')
    exit(1)
if not os.path.isfile(sys.argv[1]):
    logging.error('error: ' + str(sys.argv[1]) + ' does not exist')
    exit(1)
filename = sys.argv[1]
output_filename = filename.split('.')[0] + '-365ids.csv'

existing_array = []
try:
    with open(output_filename, 'r', encoding='utf-8') as f:
        for line in f:
            domain = line.split(',')[0]
            existing_array.append(domain)
except FileNotFoundError:
    with open(output_filename, 'w', encoding='utf-8') as f:
        f.write('domain,tenant_id' + '\n')
        f.close()
logging.info('completed ' + str(len(existing_array)) + ' existing domains')
domains_array = []
append_count = 1
with open(filename, 'r', encoding='utf-8') as f:
    for line in f:
        logging.debug('count: ' + str(append_count))
        append_count += 1
        line = line.strip()
        if line not in existing_array:
            domains_array.append(line)
logging.info('there are ' + str(len(domains_array)) + ' further domains to process')
job_count = 1
with requests.Session() as session:
    for domain in domains_array:
        domain = domain.rstrip()
        logging.debug('job ' + str(job_count) + ' of ' + str(len(domains_array)))
        tenant_id = getAADid(domain,session=session)
        job_count += 1
        logging.info(domain + ',' + str(tenant_id))
        with open(output_filename, 'a', encoding='utf-8') as f:
            f.write(domain + ',' + str(tenant_id) + '\n')
            f.close()
