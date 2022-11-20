# -*- coding: utf-8 -*-
'''
return download links for the latest version of Splunk Enterprise
'''
import logging
import requests
try:
    from bs4 import BeautifulSoup
except ImportError:
    logging.error('beautifulsoup is required and missing - refer to https://pypi.org/project/beautifulsoup4')
    exit(1)
releases_data = requests.get(
    'https://www.splunk.com/en_us/download/previous-releases.html',
    timeout=10
)
if releases_data.status_code != 200:
    logging.critical(releases_data.reason)
    exit(1)
releases_soup = BeautifulSoup(releases_data.text, 'html.parser')
release_url_segments = releases_soup.find_all('a', {'data-link': True})
release_urls_linux = []
release_urls_osx = []
release_urls_windows = []
for release_url_segment in release_url_segments:
    if release_url_segment['data-platform'] == 'linux':
        release_urls_linux.append(release_url_segment['data-link'])
    elif release_url_segment['data-platform'] == 'osx':
        release_urls_osx.append(release_url_segment['data-link'])
    elif release_url_segment['data-platform'] == 'windows':
        release_urls_windows.append(release_url_segment['data-link'])
# each release_urls_* list contains all available releases for a given platform
latest_version_linux = release_urls_linux[0].split('/')[6]
for release_url_linux in release_urls_linux:
    if latest_version_linux in release_url_linux:
        print(release_url_linux)
latest_version_osx = release_urls_osx[0].split('/')[6]
for release_url_osx in release_urls_osx:
    if latest_version_osx in release_url_osx:
        print(release_url_osx)
latest_version_windows = release_urls_windows[0].split('/')[6]
for release_url_windows in release_urls_windows:
    if latest_version_windows in release_url_windows:
        print(release_url_windows)
