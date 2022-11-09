# consume certstream wss feed, passing values to a Splunk HEC endpoint
import json
import requests
import certstream

splunk_hec = 'https://{stack}/services/collector/event'
hec_auth = {'Authorization': 'Splunk {key}'}
requests.packages.urllib3.disable_warnings()

def print_callback(message, context):
    hec_data = {
        'source': 'certstream',
        'event': message
    }
    post = requests.post(splunk_hec, json=hec_data, verify=False, headers=hec_auth)
    if post.status_code != 200:
        print(post.status_code)
        print(post.text)
        exit()

certstream.listen_for_events(print_callback, url='wss://certstream.calidog.io/')
