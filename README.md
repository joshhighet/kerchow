# useful scripts, tools n' shortcuts

---

### install the [`Brewfile`](setup/Brewfile)

##### _https://github.com/Homebrew/homebrew-bundle_

```shell
brew bundle
```

### speedtest over a shell session

```shell
yes | pv | ssh user@dest "cat >/dev/null"
```

### flush git history

```shell
git checkout --orphan release
git add -A
git commit
git branch -D main
git branch -m main
git push -f origin main
git gc --aggressive --prune=all
```

### proxmark setup

###### [_RfidResearchGroup/proxmark3/Mac-OS-X-Homebrew-Installation-Instructions.md_](https://github.com/RfidResearchGroup/proxmark3/blob/master/doc/md/Installation_Instructions/Mac-OS-X-Homebrew-Installation-Instructions.md)

```shell
brew install xquartz
brew tap RfidResearchGroup/proxmark3
brew install proxmark3
```

# useful regex

### email

```
[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}
```

### domain

```
(?=^.{4,253}$)(^((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}\.?$)
```

### ipv4

```
"^(?:[0-9]{1,3}\.){3}[0-9]{1,3}"
[1-2]?[0-9]?[0-9]\.[1-2]?[0-9]?[0-9]\.[1-2]?[0-9]?[0-9]\.[1-2]?[0-9]?[0-9]
```

### ipv6 lol

```
^(?:(?:[0-9A-Fa-f]{1,4}:){6}(?:[0-9A-Fa-f]{1,4}:[0-9A-Fa-f]{1,4}|(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))|::(?:[0-9A-Fa-f]{1,4}:){5}(?:[0-9A-Fa-f]{1,4}:[0-9A-Fa-f]{1,4}|(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))|(?:[0-9A-Fa-f]{1,4})?::(?:[0-9A-Fa-f]{1,4}:){4}(?:[0-9A-Fa-f]{1,4}:[0-9A-Fa-f]{1,4}|(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))|(?:[0-9A-Fa-f]{1,4}:[0-9A-Fa-f]{1,4})?::(?:[0-9A-Fa-f]{1,4}:){3}(?:[0-9A-Fa-f]{1,4}:[0-9A-Fa-f]{1,4}|(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))|(?:(?:[0-9A-Fa-f]{1,4}:){,2}[0-9A-Fa-f]{1,4})?::(?:[0-9A-Fa-f]{1,4}:){2}(?:[0-9A-Fa-f]{1,4}:[0-9A-Fa-f]{1,4}|(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))|(?:(?:[0-9A-Fa-f]{1,4}:){,3}[0-9A-Fa-f]{1,4})?::[0-9A-Fa-f]{1,4}:(?:[0-9A-Fa-f]{1,4}:[0-9A-Fa-f]{1,4}|(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))|(?:(?:[0-9A-Fa-f]{1,4}:){,4}[0-9A-Fa-f]{1,4})?::(?:[0-9A-Fa-f]{1,4}:[0-9A-Fa-f]{1,4}|(?:(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}(?:[0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))|(?:(?:[0-9A-Fa-f]{1,4}:){,5}[0-9A-Fa-f]{1,4})?::[0-9A-Fa-f]{1,4}|(?:(?:[0-9A-Fa-f]{1,4}:){,6}[0-9A-Fa-f]{1,4})?::)(?:%25(?:[A-Za-z0-9\\-._~]|%[0-9A-Fa-f]{2})+)?$
"(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))"
```

# recon

### directory enumerate a list of subdomains

```shell
python3 dirsearch/dirsearch.py \
--follow-redirects \
--user-agent="${useragent}" \
--json-report=dirsearch-report.json \
--recursive \
--recursive-level-max=2 \
--suppress-empty \
--extensions-list \
--exclude-status=400 \
--request-by-hostname \
--url-list=subdomains.txt \
--wordlist=db/dicc.txt
```

### tcp syn/ack scan a list of ip addresses

```shell
masscan \
--output-format JSON \
--output-filename masscan.json \
--ports 0-65535 \
--rate=10000 \
--interactive \
--wait 20 \
--banners \
--http-user-agent "${useragent}" \
-iL ips.txt
```

### get unique site pages cached by wayback machine

```shell
waybackpack "${weblocation}" \
--uniques-only \
--list \
--follow-redirects \
--user-agent "${useragent}" \
| tee waybacksites.txt
```

### get on http headers presented by an origin (method GET)

```shell
securityheaders ${weblocation} --json | tee securityheaders.json
```

### use cloud enum to list enumerate URL's for cloud storage (use notable strings)

```shell
python3 cloud_enum/cloud_enum.py 
--nameserver `cat resolvers.txt | head -n 1` \
--keyfile ${cloudenum_key} \
--logfile cloud_enum.log
```

### clone site with httrack

```shell
httrack "${weblocation}" --user-agent "${useragent}" --path "${weblocation}"
```

### sherlock - social media presence enumeration

```shell
python3 sherlock/sherlock "${string}" \
--rank --print-found --output sherlock.txt
```


### establish if a WAF is in place

```shell
wafw00f ${weblocation} --verbose \
--output=wafw00f.json
```

### webtech identifies technology stacks in use

```shell
webtech --json --urls="${weblocation}" \
--user-agent="${useragent}" \
| tee webtech.json.tmp

cat webtech.json.tmp | jq --raw-output | webtech.json
rm webtech.json.tmp
```

### using securityheaders.io, get a report of http headers presented by origin

```
securityheaders ${domain} --json \
| tee securityheaders.json
```

### use fierce to discover neighbour assets

```shell
fierce --dns-file resolvers.txt \
--domain ${ip} --search ${ip} \
| tee fierce.txt
```

### OWASP amass - subdomain enumeration engine

```shell
./amass enum -active -src \
-ip -v -brute -rf resolvers.txt \
-min-for-recursive 2 -json amass.json -d "${domain}"
```

### dnstwist - rogue domain permutation engine

```shell
dnstwist "${domain}" \
--registered \
--mxcheck \
--format json \
--nameservers 1.1.1.1,8.8.8.8 \
--useragent "${useragent}" \
| tee dnstwist.json
```

### reverse dns enumeration

```shell
python3 HostHunter/hosthunter.py \
--format csv --output hosthunter-subdomains.txt ips.txt
```

### get resolutions across all discovered subdomains

```shell
massdns/bin/massdns subdomains.txt \
--resolvers resolvers.txt \
-o J --outfile massdns.json.tmp

cat massdns.json.tmp | jq --raw-output | tee massdns.json
rm massdns.json.tmp
```