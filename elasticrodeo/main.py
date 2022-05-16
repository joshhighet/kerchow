#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
used to generate a CSV of elastic indicies exposed to the public internet
./main.py
ONION=FALSE ./main.py

{SRC}:9200/_cat/indices?v
{SRC}:9200/{INDEX}/_search?pretty=true&size=20
'''

import os
import sys
import socket
import logging
import datetime
import requests
import shodan

logging.basicConfig(level=logging.INFO)

try:
    SHODAN_API_KEY = open(os.path.expanduser("~/.shodan")).read().strip()
except FileNotFoundError:
    logging.critical("authstr missing - fetch a key from https://account.shodan.io and place it in ~/.shodan")
    sys.exit(1)

api = shodan.Shodan(SHODAN_API_KEY)

if os.path.exists('outputs'):
    logging.debug('outputs directory already exists')
else:
    os.mkdir('outputs')
    logging.debug('outputs directory created')

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
proxyprobe = sock.connect_ex(('127.0.0.1', 9050))
sock.close()

if proxyprobe != 0:
    logging.critical('socket connection to local socks proxy failed')
    sys.exit(1)

if os.environ.get('ONION') == 'FALSE':
    logging.info('onion routing explictly disabled - GET requests will originate from your local connection')
    usetor = False
else:
    logging.info('onion routing enabled for GET request availability checks - to override and leverage your own connection set envar ONION to FALSE')
    usetor = True

def checkhttp(url):
    if usetor:
        sockprox = {
            'http':  'socks5h://127.0.0.1:9050',
            'https': 'socks5h://127.0.0.1:9050'
        }
        try:
            requests.get(url, timeout=10, proxies=sockprox)
            return True
        except requests.exceptions.ConnectionError:
            return False
        except requests.exceptions.ReadTimeout:
            return False
    else:
        try:
            requests.get(url, timeout=10)
            return True
        except requests.exceptions.ConnectionError:
            return False
        except requests.exceptions.ReadTimeout:
            return False

outfilename = datetime.datetime.now().strftime("%d-%m-%Y-%H-%M-%S")
filename = 'outputs/{}.csv'.format(outfilename)
if not os.path.exists(filename):
    with open(filename, 'w', encoding='utf8') as f:
        f.write("ip, port, responsive, timestamp, orgname, city, country, hostnames, indexname, totaldocs, sizeB, sizeMB\n")

jobcount = 1

try:
    squery = 'port:9200 all:"elastic indices"'
    # squery = 'port:9200 country:NZ,AU all:"elastic indices"'
    logging.info('commencing w/ query: {}'.format(squery))
    results = api.search(squery, limit=500)
    for result in results['matches']:
        logging.info('processing {} - job {} of {}'.format(result['ip_str'], jobcount, len(results['matches'])))
        jobcount += 1
        if 'elastic' in result:
            if 'indices' in result['elastic']:
                logging.info('found {} elastic indices'.format(len(result['elastic']['indices'])))
                srcip = result['ip_str']
                port = result['port']
                lasttimestamp = result['timestamp']
                # if 'org' is nonetype set it to none
                if result['org'] is None:
                    orgname = 'none'
                else:
                    orgname = result['org'].replace(',', ' ')
                city = result['location']['city'].replace(',', ' ')
                country = result['location']['country_name'].replace(',', ' ')
                hostnames = ' '.join(result['hostnames'])
                if 'tags' in result:
                    if 'honeypot' in result['tags']:
                        logging.info(msg="{} is a shodan-tagged honeypot from org: {}".format(srcip, orgname))
                        continue
                responsive = checkhttp('http://' + srcip + ':' + str(port))
                for index in result['elastic']['indices']:
                    logging.debug('processing index {}'.format(index))
                    primary_size_b = result['elastic']['indices'][index]['primaries']['store']['size_in_bytes']
                    if primary_size_b > 0:
                        primary_size_mb = round(primary_size_b / 1024 / 1024, 5)
                    else:
                        primary_size_mb = 0
                    total_docs = result['elastic']['indices'][index]['total']['docs']['count']
                    with open(filename, 'a') as f:
                        f.write("{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}\n".format(
                            srcip,
                            port,
                            responsive,
                            lasttimestamp,
                            orgname,
                            city,
                            country,
                            hostnames,
                            index,
                            total_docs,
                            primary_size_b,
                            primary_size_mb
                            ))
            else:
                logging.info('elastic properties found though no indices seem to exist')
        else:
            logging.info('no elastic properties found')
except shodan.APIError as e:
    logging.critical(e)
