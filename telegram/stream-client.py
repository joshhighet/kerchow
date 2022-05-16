#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import logging
from configparser import ConfigParser
from telethon import TelegramClient, events

config_object = ConfigParser()
config_object.read("config.ini")
tgramapi = config_object["TELEGRAM"]

logging.basicConfig(level=logging.INFO, format='%(asctime)s %(message)s')

client = TelegramClient('anon', tgramapi['api_id'], tgramapi['api_hash'])
@client.on(events.NewMessage())
async def my_event_handler(event):
    if event.message.raw_text:
        print('message id :' + str(event.id))
        print('text: ' + str(event.message.raw_text))
        print('timestamp: ' + str(event.message.date.strftime('%Y-%m-%d %H:%M:%S')))
        print('generator: ' + str(event.from_id))
        logging.debug(event.original_update)
        logging.debug(event)
        print('--------------------------------------------------------------------------------')

logging.info('telegram | starting telethon event handling client')
client.start()
client.run_until_disconnected()
