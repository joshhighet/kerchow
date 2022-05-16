#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import logging
import json
from configparser import ConfigParser
from telethon import TelegramClient, events
from telethon.tl.functions.channels import GetFullChannelRequest
config_object = ConfigParser()
config_object.read("config.ini")
tgramapi = config_object["TELEGRAM"]

logging.basicConfig(level=logging.INFO, format='%(asctime)s %(message)s')

client = TelegramClient('anon', tgramapi['api_id'], tgramapi['api_hash'])
client.start()
dialog_array = {}

for dialog in client.iter_dialogs():
    if not dialog.is_group and dialog.is_channel:
        dialog_array[dialog.id] = dialog.title

print(json.dumps(dialog_array))
