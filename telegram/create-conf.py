#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
helps create the configuration file required for runtime
interactive for inputting secrets
'''

from configparser import ConfigParser

import getpass
import os
import sys

tgram_api_id = input('your telegram api id: ')
tgram_api_hash = input('your telegram api hash: ')

config_object = ConfigParser()

config_object["SOCKSPROXY"] = {
    "ipaddr": "127.0.0.1",
    "port": 9050
}

config_object["TELEGRAM"] = {
    "api_id": tgram_api_id,
    "api_hash": tgram_api_hash
}

with open('config.ini', 'w', encoding='utf-8') as conf:
    config_object.write(conf)
