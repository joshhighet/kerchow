import json
import requests
url = "https://check.torproject.org/exit-addresses"
response = requests.get(url)
exit_addresses = response.text
exit_ips = []
for line in exit_addresses.split("\n"):
    if "ExitAddress" in line:
        exit_ip = line.split(" ")[1]
        exit_ips.append(exit_ip)
data = []
for ip in exit_ips:
    data.append(ip)
print(json.dumps(data, indent=4))
