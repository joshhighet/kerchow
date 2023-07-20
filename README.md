# kerchow

kerchow is a collection of shortcuts/binfiles/scripts to speed up common tasks

these are intended to be added to your `PATH` to shorthand various workflows - _see `setup.zsh` for an example_

each script is noted below alongside a brief description of what it does. where applicable, example outputs are shown

---

## boing

[:link:](sbin/boing) _makes an audible boing noise (can be useful for long-running scripts)_

<details><summary>example:</summary>

```
➜  labs boing
🔊
```
</details>

## cats

[:link:](sbin/cats) _print the source code of any kerchow shortscripts_

<details><summary>example:</summary>

```
➜  labs cats cats
#!/bin/bash
# print the source code of any kerchow shortscripts

if [ -z "$1" ]; then
    echo "usage: cats <binfile>"
    exit 1
fi

shortscript=`which $1`

if [ -z "$shortscript" ]; then
  echo "unable to find $1"
  exit 1
fi

if ! command -v bat >/dev/null 2>&1
then
  cat $shortscript
else
  bat -pp $shortscript
fi
```
</details>

## certinfo

[:link:](sbin/certinfo) _returns x509 data in json for a given url_

<details><summary>example:</summary>

```
➜  labs certinfo dotco.nz | jq
{
  "subject": {
    "commonName": "dotco.nz"
  },
  "issuer": {
    "countryName": "US",
    "organizationName": "Google Trust Services LLC",
    "commonName": "GTS CA 1P5"
  },
  "version": 3,
  "serialNumber": "A936F40B7782FFCA110322E22CA11D03",
  "notBefore": "May 22 23:43:14 2023 GMT",
  "notAfter": "Aug 20 23:43:13 2023 GMT",
  "subjectAltName": [
    "dotco.nz",
    "*.dotco.nz"
  ],
  "OCSP": [
    "http://ocsp.pki.goog/s/gts1p5/JNQ39h5OCqA"
  ],
  "caIssuers": [
    "http://pki.goog/repo/certs/gts1p5.der"
  ],
  "crlDistributionPoints": [
    "http://crls.pki.goog/gts1p5/UMpHrkS7PMY.crl"
  ]
}
```
</details>

## cfssh

[:link:](sbin/cfssh) _use the cloudflared tunnel agent to ssh onto a target fqdn_

## checkmsuser

[:link:](sbin/checkmsuser) _check if a given email address has a connected m365 account_

<details><summary>example:</summary>

```
➜  labs checkmsuser bill.gates@microsoft.com
{
  "external_idp": true,
  "valid_account": true
}
```
</details>

## colortest

[:link:](sbin/colortest) _test colors on a shell_

<details><summary>example:</summary>

```
➜  labs colortest
            40m   41m   42m   43m   44m   45m   46m   47m
    m gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw
  1;m gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw
  30m gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw
1;30m gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw
  31m gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw
1;31m gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw
  32m gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw
1;32m gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw
  33m gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw
1;33m gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw
  34m gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw
1;34m gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw
  35m gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw
1;35m gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw
  36m gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw
1;36m gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw
  37m gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw
1;37m gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw   gYw
```
</details>

## crtsh

[:link:](sbin/crtsh) _use the crt.sh ct api to discover other web services for an apex domain_

<details><summary>example:</summary>

```
➜  labs crtsh dotco.nz
*.dotco.nz
dotco.nz
s.dotco.nz
www.dotco.nz
```
</details>

## cruises

[:link:](sbin/cruises) _fetch incoming auckland port ship data_

## curltor

[:link:](sbin/curltor) _wrapper for curling onionsites with a local/remote tor client over socks5_

<details><summary>example:</summary>

```
➜  labs curltor -I ciadotgov4sjwlzihbbgxnqg3xiyrg7so2r2o3lt5wz5ypk4sxyjstad.onion
Connection to telemetry.dark port 9050 [tcp/*] succeeded!
HTTP/1.1 301 Moved Permanently
Date: Thu, 20 Jul 2023 08:08:53 GMT
Content-Length: 0
Location: http://ciadotgov4sjwlzihbbgxnqg3xiyrg7so2r2o3lt5wz5ypk4sxyjstad.onion/index.html
Connection: keep-alive
Set-Cookie: _session_={xxx}; path=/; domain=ciadotgov4sjwlzihbbgxnqg3xiyrg7so2r2o3lt5wz5ypk4sxyjstad.onion; secure; HttpOnly
```
</details>

## dehashed-email

[:link:](sbin/dehashed-email) _get dehashed results for an email_

## dex

[:link:](sbin/dex) _get a shell in the latest built docker container_

## digall

[:link:](sbin/digall) _perform a dig ANY lookup using google DNS for a given domain_

<details><summary>example:</summary>

```
➜  labs digall google.com
172.217.167.78
2404:6800:4006:80a::200e
"globalsign-smime-dv=CDYX+XFHUw2wml6/Gb8+59BsH31KzUr6c1l2BPvqKX8="
"onetrust-domain-verification=de01ed21f2fa4d8781cbc3ffb89cf4ef"
ns4.google.com.
"v=spf1 include:_spf.google.com ~all"
ns1.google.com.
"MS=E4A68B9AB2BB9670BCE15412F62916164C0B20BB"
\# 13 00010000010006026832026833
ns2.google.com.
ns1.google.com. dns-admin.google.com. 549264082 900 900 1800 60
"google-site-verification=wD8N7i1JTNTkezJ49swvWW48f8_9xveREV4oB-0Hf5o"
"apple-domain-verification=30afIBcvSuDV2PLX"
0 issue "pki.goog"
10 smtp.google.com.
"atlassian-domain-verification=5YjTmWmjI92ewqkx2oXmBaD60Td9zWon9r6eakvHX6B77zzkFQto8PQ9QsKnbf4I"
ns3.google.com.
"docusign=05958488-4752-4ef2-95eb-aa7ba8a3bd0e"
"facebook-domain-verification=22rm551cu4k0ab0bxsw536tlds4h95"
"docusign=1b0a6754-49b1-4db5-8540-d2c12664b289"
"webexdomainverification.8YX6G=6e6922db-e3e6-4a36-904e-a805c28087fa"
"google-site-verification=TV9-DBe4R80X4v0M4U_bd_J9cpOJM0nikft0jAgjmsQ"
```
</details>

## dim

[:link:](sbin/dim) _list all docker images on current system_

## dol

[:link:](sbin/dol) _get logs of the latest or specified container_

## down

[:link:](sbin/down) _take down the current dir docker compose instance_

## dps

[:link:](sbin/dps) _list current running docker containers_

## drm

[:link:](sbin/drm) _kill latest or specified docker container_

## dup

[:link:](sbin/dup) _advanced shortcut for docker compose up_

## edns

[:link:](sbin/edns) _displays your current external/upstream dns resolver_

<details><summary>example:</summary>

```
➜  labs edns
{
  "dns": {
    "geo": "New Zealand - Cloudflare, Inc.",
    "ip": "198.41.237.25"
  }
}
```
</details>

## feedread-certnz

[:link:](sbin/feedread-certnz) _show the latest posts on the certnz advisories page_

## feedread-ncscnz

[:link:](sbin/feedread-ncscnz) _show the latest posts on the ncsc nz advisories page_

## finfo

[:link:](sbin/finfo) _returns useful file information & hashes_

<details><summary>example:</summary>

```
➜  labs finfo /usr/bin/curl
info     | [x86_64:Mach-O 64-bit executable x86_64] [arm64e:Mach-O 64-bit executable arm64e]
/usr/bin/curl (for architecture x86_64):	Mach-O 64-bit executable x86_64
/usr/bin/curl (for architecture arm64e):	Mach-O 64-bit executable arm64e
size     | 292K
modified | 06/15/2023 22:08:29
created  | 06/15/2023 22:08:29
sha1     | 3f6ea6f27592759fdb2df2943d6a5117cacb58c5
sha2     | 361822e42482e3197de5cac35029c4cd08deb89f4118a014cdc13ca6f3456ead
sha5     | 6a3d0fd105095beee01f149eff4ed39eacf5cf01bedba1fae220c56ce1904291143135fd0bbe0d40b6c6bf91c93c9209235480071d2a4476ae2ad918b3e3ea68
md5      | 3541bb282be981fa399ff60764709988
crc32    | 66b11e8a
```
</details>

## fixairplay

[:link:](sbin/fixairplay) _fix a broken airplay2 session_

## flushdns

[:link:](sbin/flushdns) _flush dns cache on macOS_

## freewilly

[:link:](sbin/freewilly) _clean all docker images and networks_

## ga

[:link:](sbin/ga) _git add shortcut for all files or the specified ones_

## gb

[:link:](sbin/gb) _list current git branches - if given var1 then change to or create that branch name_

## gc

[:link:](sbin/gc) _clone a remote repo to local into current dir_

## get-urlscansubs

[:link:](sbin/get-urlscansubs) _build datasets of active url's from urlscan _

<details><summary>example:</summary>

```
➜  labs get-urlscansubs
WARNING:root:no api key supplied with --api, once we are rate limited i will die
INFO:root:saved urlscan-submissions.json
INFO:root:working on: https://status.solidvpn.org/
```
</details>

## getlargefiles

[:link:](sbin/getlargefiles) _returns a list of the largest files on disk (top 5 unless arg1 set)_

## getmstenant

[:link:](sbin/getmstenant) _get the microsoft 365 tenantid for a given domain_

<details><summary>example:</summary>

```
➜  labs getmstenant apple.com
ba8f4151-ab0e-4da6-862d-68b05906e887
```
</details>

## getshbanner

[:link:](sbin/getshbanner) _fetch a ssh banner from a given server_

<details><summary>example:</summary>

```
➜  labs getshbanner telemetry.dark

 _     _       _                _
| |__ (_) __ _| |__  _ __   ___| |_
| '_ \| |/ _` | '_ \| '_ \ / _ \ __|
| | | | | (_| | | | | | | |  __/ |_
|_| |_|_|\__, |_| |_|_| |_|\___|\__|
         |___/	      telemetry.dark
```
</details>

## getwordlists

[:link:](sbin/getwordlists) _fetch a TON of wordlists for... science_

## ginfo

[:link:](sbin/ginfo) _get basic into on the git repo you are within (upstream url, description)_

<details><summary>example:</summary>

```
➜  kerchow git:(main) ✗ ginfo
url: https://github.com/joshhighet/kerchow
last author: josh!
description: amplify your terminal for security research  🏎 🖥️
last commit: 2023-05-15 17:48:03 +1200
```
</details>

## git-updatesubmodules

[:link:](sbin/git-updatesubmodules) _update all submodules within a git project recursivley_

## gitcreds

[:link:](sbin/gitcreds) _use trufflehog to search the current working dir for creds_

## gitgetcontributors

[:link:](sbin/gitgetcontributors) _return a list of emails that have contributed to a git project_

## github-get-all-repo-for-profile

[:link:](sbin/github-get-all-repo-for-profile) _print all the public repositories for a given github username_

<details><summary>example:</summary>

```
github-get-all-repo-for-profile apple | grep darwin
https://github.com/apple/darwin-libplatform
https://github.com/apple/darwin-libpthread
https://github.com/apple/darwin-xnu
```
</details>

## github-rm-workflowruns

[:link:](sbin/github-rm-workflowruns) _will go through a github repository and remove all previous workflow data_

## gitsubrm

[:link:](sbin/gitsubrm) _remove a git submodule from a git repo_

## gitsubs

[:link:](sbin/gitsubs) _initalise and update submodules within a git repository (git submodule init & update)_

## gl

[:link:](sbin/gl) _git pull the updates of the current dir structure_

## google

[:link:](sbin/google) _googles arg1 in the default brower/handler for http, macos only_

## gp

[:link:](sbin/gp) _auto commit and push changes. var1 can be commit message or it will prompt for one. dont use spaces_

## grepapp

[:link:](sbin/grepapp) _search for a string in public source repositories with grep.app_

<details><summary>example:</summary>

```
➜  /tmp grepapp joshhighet.com
{
  "facets": {
    "count": 1,
    "lang": {
      "buckets": [
        {
          "count": 1,
          "val": "Shell"
        }
      ]
    },
    "path": {
      "buckets": [
        {
          "count": 1,
          "val": "sbin/"
        }
      ]
    },
    "repo": {
      "buckets": [
        {
          "count": 1,
          "owner_id": "17993143",
          "val": "joshhighet/kerchow"
        }
      ]
    }
  },
  "hits": {
    "hits": [
      {
        "branch": {
          "raw": "main"
        },
        "content": {
          "snippet": "<table class=\"highlight-table\"><tr data-line=\"6\"><td><div class=\"lineno\">6</div></td><td><div class=\"highlight\"><pre>    <span class=\"nb\">echo</span> <span class=\"s1\">&#39;domain &amp; path required&#39;</span></pre></div></td></tr><tr data-line=\"7\"><td><div class=\"lineno\">7</div></td><td><div class=\"highlight\"><pre>    <span class=\"nb\">echo</span> <span class=\"s1\">&#39;http-scanner https://cdn.<mark>joshhighet.com</mark> /images/me.png&#39;</span></pre></div></td></tr><tr data-line=\"8\"><td><div class=\"lineno\">8</div></td><td><div class=\"highlight\"><pre>    <span class=\"nb\">exit</span> <span class=\"m\">1</span></pre></div></td></tr></table>"
        },
        "id": {
          "raw": "g/joshhighet/kerchow/main/sbin/http-scanner"
        },
        "owner_id": {
          "raw": "17993143"
        },
        "path": {
          "raw": "sbin/http-scanner"
        },
        "repo": {
          "raw": "joshhighet/kerchow"
        },
        "total_matches": {
          "raw": "1"
        }
      }
    ],
    "total": 1
  },
  "partial": false,
  "time": 78
}
```
</details>

## greps

[:link:](sbin/greps) _search the scripts directory for keyword_

## gs

[:link:](sbin/gs) _shortcut git status info_

## gsa

[:link:](sbin/gsa) _shortcut git submodule add_

## hackertarget

[:link:](sbin/hackertarget) _lookup assets with hackertarget for a given domain name_

<details><summary>example:</summary>

```
➜  kerchow git:(main) ✗ hackertarget apple.co.nz
store.apple.co.nz
shop.apple.co.nz
consultants.apple.co.nz
```
</details>

## hashdir

[:link:](sbin/hashdir) _show sha2 checksums for all files within a directory (full depth)_

<details><summary>example:</summary>

```
➜  labs cd ransomwatch/assets
➜  assets git:(main) hashdir
a1b42b4205b39fb07788449efd84cf2946e5e1d31e8d53f0d896c591982e0bf1  ./browse-hosts.sh
9d4d2e7832f3941012efa7b545a408b18ddfaa5a145762b0204044af8bf803e9  ./chromium.py
5b3572e75c5777ca02c6c918a1b993c83a7d20096a130976d853600fb02de0b6  ./dir
8dee5e8d9c7e5b6a56bf8326007c9803b701e28d7b419a6f62f4b89a623b37dd  ./groups-kv.json
fb1511c92b385d0fbc6bb175113500ef092608163c9e700b3b6d1ac18ffbc74a  ./groups-kv.py
d4cca1ef5d96b2f001cfd58c5aff006af9b88f7d230ae617b6701485e3b0590a  ./iter_headers.sh
f73838fc8d471824802cdebdfd648d09ced9ac4b91e42697bbfb2373b532b9f9  ./parsers.sh
ce38889f509e8ecc9866a28671b0b10ba99a501a00f1070ef672ef73cffa9c1e  ./screenshotter.py
810000cc8fa3a548ffde013b3fed619b69665b87109b7fa4e73662ce097d455f  ./sources.exclusions
dfd2e463400e07b83446e68895ca87d432ee4cfab3de76232484cc03c6ad22fb  ./sources.zsh
56687410895543af2665b7031d9e0f8d9769fa6974808d3ce355b47409b9ec75  ./srcanalyser.py
c0b64148c45d6cb751b6b56277b4654d7f626dc53436a1d2033d622ca97daba4  ./uptimekuma-importer.py
e2654ba7d11b67dda187f2bb4a2b68b22f4c064fcc4a90aa074a7a69e8d55015  ./useragents.txt
```
</details>

## headers

[:link:](sbin/headers) _show the headers returned by a URI (GET)_

<details><summary>example:</summary>

```
➜  labs headers google.com
HTTP/1.1 301 Moved Permanently
Location: http://www.google.com/
Content-Type: text/html; charset=UTF-8
Content-Security-Policy-Report-Only: object-src 'none';base-uri 'self';script-src 'nonce-AdeI7EpTrBpQWpoLjaWhwg' 'strict-dynamic' 'report-sample' 'unsafe-eval' 'unsafe-inline' https: http:;report-uri https://csp.withgoogle.com/csp/gws/other-hp
Date: Thu, 20 Jul 2023 21:32:27 GMT
Expires: Sat, 19 Aug 2023 21:32:27 GMT
Cache-Control: public, max-age=2592000
Server: gws
Content-Length: 219
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN
```
</details>

## http

[:link:](sbin/http) _python3 simple http server_

## http-loadtest

[:link:](sbin/http-loadtest) _make requests with apachabench_

## http-responder

[:link:](sbin/http-responder) _simple webserver to validate ownership checks (used for Splunk HEC with Meraki Local Analytics API)_

## http-scanner

[:link:](sbin/http-scanner) _run a suite of url checks for the cyber ??_

## intip

[:link:](sbin/intip) _try determine current internal ip_

## ipgrep

[:link:](sbin/ipgrep) _search input for ipv4 and ipv6 addresses_

<details><summary>example:</summary>

```
➜  labs echo '''<!DOCTYPE html>
<html>
<head>
  <title>hello</title>
</head>
<body>
  <h1>2001:db8:3333:4444:5555:6666:7777:8888</h1>
  <h2>192.168.1.6</h2>
</body>
</html>''' | ipgrep
2001:db8:3333:4444:5555:6666:7777:8888
192.168.1.6
```
</details>

## ipgrepv4

[:link:](sbin/ipgrepv4) _read stdin and list any IPv4 addresses_

<details><summary>example:</summary>

```
➜  labs echo '''<!DOCTYPE html>
<html>
<head>
  <title>hello</title>
</head>
<body>
  <h1>10.23.24.25</h1>
</body>
</html>''' | ipgrepv4
10.23.24.25
```
</details>

## ipgrepv6

[:link:](sbin/ipgrepv6) _read stdin and list any IPv6 addresses_

<details><summary>example:</summary>

```
➜  labs echo '''<!DOCTYPE html>
<html>
<head>
  <title>hello</title>
</head>
<body>
  <h1>2001:db8:3333:4444:5555:6666:7777:8888</h1>
</body>
</html>''' | ipgrepv6
2001:db8:3333:4444:5555:6666:7777:8888
```
</details>

## ipi

[:link:](sbin/ipi) _query IP API for any IP details - beware, ip-api believe TLS is a premium feature_

<details><summary>example:</summary>

```
➜  labs ipi 1.1.1.1
{
  "status"       : "success",
  "continent"    : "Oceania",
  "continentCode": "OC",
  "country"      : "Australia",
  "countryCode"  : "AU",
  "region"       : "QLD",
  "regionName"   : "Queensland",
  "city"         : "South Brisbane",
  "district"     : "",
  "zip"          : "4101",
  "lat"          : -27.4766,
  "lon"          : 153.0166,
  "timezone"     : "Australia/Brisbane",
  "offset"       : 36000,
  "currency"     : "AUD",
  "isp"          : "Cloudflare, Inc",
  "org"          : "APNIC and Cloudflare DNS Resolver project",
  "as"           : "AS13335 Cloudflare, Inc.",
  "asname"       : "CLOUDFLARENET",
  "mobile"       : false,
  "proxy"        : false,
  "hosting"      : true,
  "query"        : "1.1.1.1"
}
```
</details>

## ipinfo

[:link:](sbin/ipinfo) _basic cli netaddress enrichment with greynoise, virustotal & ipinfo_

<details><summary>example:</summary>

```
➜  labs ipinfo 1.1.1.1

hostname  one.one.one.one
anycast   true
country   US
loc       34.0522,-118.2437
postal    90076
timezone  America/Los_Angeles
harmless    67
malicious   2
suspicious  0
undetected  19
timeout     0

rgcrjsqaalucmmlfom3s26bygywtmna.h.nessus.org
rgcrjsqaalucmelfom3s26bygywtmna.h.nessus.org
microsoft.amch-1dnj.sbs
www.microsoft.amch-1dnj.sbs
this.www.microsoft.amch-1dnj.sbs
with.this.www.microsoft.amch-1dnj.sbs
want_to.with.this.www.microsoft.amch-1dnj.sbs
do_yo.want_to.with.this.www.microsoft.amch-1dnj.sbs
uk.do_yo.want_to.with.this.www.microsoft.amch-1dnj.sbs
co.uk.do_yo.want_to.with.this.www.microsoft.amch-1dnj.sbs

noise           false
riot            true
classification  benign
link            https://viz.greynoise.io/riot/1.1.1.1
last_seen       2023-07-20
```
</details>

## iptables-clear

[:link:](sbin/iptables-clear) _drop all iptables chains_

## kserve

[:link:](sbin/kserve) _list all defined kubernetes deployments_

## l

[:link:](sbin/l) _list current directory_

## maclean

[:link:](sbin/maclean) _macos: empty trash, clear system logs & clear download history from quarantine_

## macupd

[:link:](sbin/macupd) _macos: update os, applications, homebrew etc_

## mailcheck

[:link:](sbin/mailcheck) _lookup SPF, MX & DMARC records for a domain_

<details><summary>example:</summary>

```
➜  labs mailcheck apple.com
SPF: "v=spf1 include:_spf.apple.com include:_spf-txn.apple.com ~all"
DMARC: "v=DMARC1; p=quarantine; sp=reject; rua=mailto:d@rua.agari.com; ruf=mailto:d@ruf.agari.com;"
MX: mx-in.g.apple.com.
MX: mx-in-vib.apple.com.
MX: mx-in-mdn.apple.com.
MX: mx-in-rno.apple.com.
MX: mx-in-hfd.apple.com.
```
</details>

## mgrep

[:link:](sbin/mgrep) _best attempts grep for email_

<details><summary>example:</summary>

```
➜  labs echo '''<!DOCTYPE html>
<html>
<head>
  <title>hello</title>
</head>
<body>
  <h1>bill.gates@microsoft.com</h1>
</body>
</html>''' | mgrep
bill.gates@microsoft.com
```
</details>

## myip

[:link:](sbin/myip) _return my current IP address_

## n

[:link:](sbin/n) _nano shortcut_

## npmaudit

[:link:](sbin/npmaudit) _auto audit the local package.json and produce 'report.html' output_

## nz-companiesdirectory

[:link:](sbin/nz-companiesdirectory) _search the NZ companies directory_

## onionscan

[:link:](sbin/onionscan) _netscan an onion address with proxychains, jsonified output_

## openh

[:link:](sbin/openh) _open an fqdn in a browser_

## osq-usb

[:link:](sbin/osq-usb) _use osquery to return a list of attached removable usb devices_

## osv

[:link:](sbin/osv) _return a known OS version string_

## ouilookup

[:link:](sbin/ouilookup) _lookups a mac address in attempt to vendor correlate_

<details><summary>example:</summary>

```
➜  labs ouilookup 00-B0-D0-63-C2-26
00B0D0 (base 16) Dell Inc.
```
</details>

## pans

[:link:](sbin/pans) _list valid NZ PANs forever or until var1=numberToReturn_

## phishreport

[:link:](sbin/phishreport) _report a URL to phish.report_

## pihole-disable

[:link:](sbin/pihole-disable) _disable pihole filtering_

## pihole-enable

[:link:](sbin/pihole-enable) _enable pihole filtering_

## pihole-lastblock

[:link:](sbin/pihole-lastblock) _show the last domain blocked by pihole_

## pihole-stat

[:link:](sbin/pihole-stat) _get basic stats of a pihole instance from the php api_

## pireq

[:link:](sbin/pireq) _shortcut to install python3 deps from requirements.txt_

## ports

[:link:](sbin/ports) _shows running service network interaction (listening ports)_

## pping

[:link:](sbin/pping) _pingsweep (or tcp chek if port provided as arg1)_

## pubkey

[:link:](sbin/pubkey) _print my public keys_

## pullallrepos

[:link:](sbin/pullallrepos) _enter into all folders within the current working directory - if the folder is a git repo pull the latest from remote_

## ransomwatch-groupcounts

[:link:](sbin/ransomwatch-groupcounts) _return a list of all online ransomwatch hosts_

## ransomwatch-groups

[:link:](sbin/ransomwatch-groups) _return ransomwatch groups_

## ransomwatch-online

[:link:](sbin/ransomwatch-online) _return a list of all online ransomwatch hosts_

## ransomwatch-posts

[:link:](sbin/ransomwatch-posts) _return a list of posts in ransomwatch_

## redirect

[:link:](sbin/redirect) _follow a URL and return the destination after redirects_

<details><summary>example:</summary>

```
➜  kerchow git:(main) ✗ redirect google.com
https://www.google.com/?gws_rd=ssl
```
</details>

## reversewhois

[:link:](sbin/reversewhois) _perform reverse whois lookup using the viewdns.info api_

<details><summary>example:</summary>

```
➜  labs reversewhois domains@apple.com
applecare.pro
applecare.promo
applecare.qpon
applecare.quebec
applecare.rent
applecare.review
applecare.services
applecare.site
applecare.soy
applecare.space
applecare.store
applecare.study
applecare.sucks
applecare.sydney
applecare.taipei
applecare.tech
applecare.tel
applecare.tokyo
applecare.university
applecare.us
applecare.vegas
applecare.wang
```
</details>

## searchcode

[:link:](sbin/searchcode) _search for a string in public source repositories with searchcode_

## servicescan

[:link:](sbin/servicescan) _use nmap to run a service identification scan (ip and optional port)_

<details><summary>example:</summary>

```
➜  labs servicescan 1.1.1.1 53
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-21 09:19 NZST
Nmap scan report for one.one.one.one (1.1.1.1)
Host is up (0.0083s latency).

PORT   STATE SERVICE VERSION
53/tcp open  domain  Unbound

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 6.44 seconds
```
</details>

## shodanme

[:link:](sbin/shodanme) _shodan your current egress address_

## ssh-nokey

[:link:](sbin/ssh-nokey) _ssh to rogue hosts without presenting a local key_

## sshmd5

[:link:](sbin/sshmd5) _generate an md5 signature of a ssh server_

## sssh

[:link:](sbin/sssh) _multi-host ssh controller_

## tor-getLatestConsensus

[:link:](sbin/tor-getLatestConsensus) _fetch the latest consensus file from metrics.torproject.org for processing_

## tor-readyyet

[:link:](sbin/tor-readyyet) _this checks if a tor circuit has been completed by polling the controlport_

## torexits-jsonarray

[:link:](sbin/torexits-jsonarray) _returns a JSON array of public Tor exit nodes_

## tornz

[:link:](sbin/tornz) _return overview on tor bridges, exits & open relays [nz netspace]_

## urld

[:link:](sbin/urld) _decode a url_

<details><summary>example:</summary>

```
➜  labs urld https%3A%2F%2Fdotco.nz%2Fsearch%3Fquery%3Dexe.png
https://dotco.nz/search?query=exe.png
```
</details>

## utc

[:link:](sbin/utc) _list given date as UTC time_

## validpan

[:link:](sbin/validpan) _check if a given credit card number (var1) passes mod10 checksum_

## wa

[:link:](sbin/wa) _colorful watch wrapper for localhost (local http develop) - takes port as $1_

## webspeed

[:link:](sbin/webspeed) _website speed tests (response time analytics)_

<details><summary>example:</summary>

```
➜  labs webspeed dotco.nz
report: http://dotco.nz/

lookup time:		0.008208
connect time:		0.116452
appcon time:		0.000000
redirect time:		0.000000
pre-transfer time:	0.116502
start-transfer time:	0.162668

total time:		0.162746
```
</details>

## wgetspider

[:link:](sbin/wgetspider) _spider/download a site using wget into './downloaded'_

## whatmydns

[:link:](sbin/whatmydns) _show current dns servers_

## whatport

[:link:](sbin/whatport) _search for common port usages (what does port 763 correspond to)_

<details><summary>example:</summary>

```
➜  labs whatport 1230
{
  "udp": {
    "service": "periscope",
    "name": "Periscope"
  },
  "tcp": {
    "service": "periscope",
    "name": "Periscope"
  }
}
```
</details>

## zonetransfer

[:link:](sbin/zonetransfer) _attempt an DNS AXFR (zone transfer) with dig on arg1_

<details><summary>example:</summary>

```
➜  /tmp zonetransfer zonetransfer.me
attempting zone txfr on zonetransfer.me, nameserver nsztm2.digi.ninja.
zonetransfer.me.	7200	IN	SOA	nsztm1.digi.ninja. robin.digi.ninja. 2019100801 172800 900 1209600 3600
zonetransfer.me.	300	IN	HINFO	"Casio fx-700G" "Windows XP"
zonetransfer.me.	301	IN	TXT	"google-site-verification=tyP28J7JAUHA9fw2sHXMgcCC0I6XBmmoVi04VlMewxA"
zonetransfer.me.	7200	IN	MX	0 ASPMX.L.GOOGLE.COM.
zonetransfer.me.	7200	IN	MX	10 ALT1.ASPMX.L.GOOGLE.COM.
zonetransfer.me.	7200	IN	MX	10 ALT2.ASPMX.L.GOOGLE.COM.
zonetransfer.me.	7200	IN	MX	20 ASPMX2.GOOGLEMAIL.COM.
zonetransfer.me.	7200	IN	MX	20 ASPMX3.GOOGLEMAIL.COM.
zonetransfer.me.	7200	IN	MX	20 ASPMX4.GOOGLEMAIL.COM.
zonetransfer.me.	7200	IN	MX	20 ASPMX5.GOOGLEMAIL.COM.
zonetransfer.me.	7200	IN	A	5.196.105.14
zonetransfer.me.	7200	IN	NS	nsztm1.digi.ninja.
zonetransfer.me.	7200	IN	NS	nsztm2.digi.ninja.
_acme-challenge.zonetransfer.me. 301 IN	TXT	"2acOp15rSxBpyF6L7TqnAoW8aI0vqMU5kpXQW7q4egc"
_acme-challenge.zonetransfer.me. 301 IN	TXT	"6Oa05hbUJ9xSsvYy7pApQvwCUSSGgxvrbdizjePEsZI"
_sip._tcp.zonetransfer.me. 14000 IN	SRV	0 0 5060 www.zonetransfer.me.
14.105.196.5.IN-ADDR.ARPA.zonetransfer.me. 7200	IN PTR www.zonetransfer.me.
asfdbauthdns.zonetransfer.me. 7900 IN	AFSDB	1 asfdbbox.zonetransfer.me.
asfdbbox.zonetransfer.me. 7200	IN	A	127.0.0.1
asfdbvolume.zonetransfer.me. 7800 IN	AFSDB	1 asfdbbox.zonetransfer.me.
canberra-office.zonetransfer.me. 7200 IN A	202.14.81.230
cmdexec.zonetransfer.me. 300	IN	TXT	"; ls"
contact.zonetransfer.me. 2592000 IN	TXT	"Remember to call or email Pippa on +44 123 4567890 or pippa@zonetransfer.me when making DNS changes"
dc-office.zonetransfer.me. 7200	IN	A	143.228.181.132
deadbeef.zonetransfer.me. 7201	IN	AAAA	dead:beaf::
dr.zonetransfer.me.	300	IN	LOC	53 20 56.558 N 1 38 33.526 W 0.00m 1m 10000m 10m
DZC.zonetransfer.me.	7200	IN	TXT	"AbCdEfG"
email.zonetransfer.me.	2222	IN	NAPTR	1 1 "P" "E2U+email" "" email.zonetransfer.me.zonetransfer.me.
email.zonetransfer.me.	7200	IN	A	74.125.206.26
Hello.zonetransfer.me.	7200	IN	TXT	"Hi to Josh and all his class"
home.zonetransfer.me.	7200	IN	A	127.0.0.1
Info.zonetransfer.me.	7200	IN	TXT	"ZoneTransfer.me service provided by Robin Wood - robin@digi.ninja. See http://digi.ninja/projects/zonetransferme.php for more information."
internal.zonetransfer.me. 300	IN	NS	intns1.zonetransfer.me.
internal.zonetransfer.me. 300	IN	NS	intns2.zonetransfer.me.
intns1.zonetransfer.me.	300	IN	A	81.4.108.41
intns2.zonetransfer.me.	300	IN	A	52.91.28.78
office.zonetransfer.me.	7200	IN	A	4.23.39.254
ipv6actnow.org.zonetransfer.me.	7200 IN	AAAA	2001:67c:2e8:11::c100:1332
owa.zonetransfer.me.	7200	IN	A	207.46.197.32
robinwood.zonetransfer.me. 302	IN	TXT	"Robin Wood"
rp.zonetransfer.me.	321	IN	RP	robin.zonetransfer.me. robinwood.zonetransfer.me.
sip.zonetransfer.me.	3333	IN	NAPTR	2 3 "P" "E2U+sip" "!^.*$!sip:customer-service@zonetransfer.me!" .
sqli.zonetransfer.me.	300	IN	TXT	"' or 1=1 --"
sshock.zonetransfer.me.	7200	IN	TXT	"() { :]}; echo ShellShocked"
staging.zonetransfer.me. 7200	IN	CNAME	www.sydneyoperahouse.com.
alltcpportsopen.firewall.test.zonetransfer.me. 301 IN A	127.0.0.1
testing.zonetransfer.me. 301	IN	CNAME	www.zonetransfer.me.
vpn.zonetransfer.me.	4000	IN	A	174.36.59.154
www.zonetransfer.me.	7200	IN	A	5.196.105.14
xss.zonetransfer.me.	300	IN	TXT	"'><script>alert('Boo')</script>"
zonetransfer.me.	7200	IN	SOA	nsztm1.digi.ninja. robin.digi.ninja. 2019100801 172800 900 1209600 3600

attempting zone txfr on zonetransfer.me, nameserver nsztm1.digi.ninja.
zonetransfer.me.	7200	IN	SOA	nsztm1.digi.ninja. robin.digi.ninja. 2019100801 172800 900 1209600 3600
zonetransfer.me.	300	IN	HINFO	"Casio fx-700G" "Windows XP"
zonetransfer.me.	301	IN	TXT	"google-site-verification=tyP28J7JAUHA9fw2sHXMgcCC0I6XBmmoVi04VlMewxA"
zonetransfer.me.	7200	IN	MX	0 ASPMX.L.GOOGLE.COM.
zonetransfer.me.	7200	IN	MX	10 ALT1.ASPMX.L.GOOGLE.COM.
zonetransfer.me.	7200	IN	MX	10 ALT2.ASPMX.L.GOOGLE.COM.
zonetransfer.me.	7200	IN	MX	20 ASPMX2.GOOGLEMAIL.COM.
zonetransfer.me.	7200	IN	MX	20 ASPMX3.GOOGLEMAIL.COM.
zonetransfer.me.	7200	IN	MX	20 ASPMX4.GOOGLEMAIL.COM.
zonetransfer.me.	7200	IN	MX	20 ASPMX5.GOOGLEMAIL.COM.
zonetransfer.me.	7200	IN	A	5.196.105.14
zonetransfer.me.	7200	IN	NS	nsztm1.digi.ninja.
zonetransfer.me.	7200	IN	NS	nsztm2.digi.ninja.
_acme-challenge.zonetransfer.me. 301 IN	TXT	"6Oa05hbUJ9xSsvYy7pApQvwCUSSGgxvrbdizjePEsZI"
_sip._tcp.zonetransfer.me. 14000 IN	SRV	0 0 5060 www.zonetransfer.me.
14.105.196.5.IN-ADDR.ARPA.zonetransfer.me. 7200	IN PTR www.zonetransfer.me.
asfdbauthdns.zonetransfer.me. 7900 IN	AFSDB	1 asfdbbox.zonetransfer.me.
asfdbbox.zonetransfer.me. 7200	IN	A	127.0.0.1
asfdbvolume.zonetransfer.me. 7800 IN	AFSDB	1 asfdbbox.zonetransfer.me.
canberra-office.zonetransfer.me. 7200 IN A	202.14.81.230
cmdexec.zonetransfer.me. 300	IN	TXT	"; ls"
contact.zonetransfer.me. 2592000 IN	TXT	"Remember to call or email Pippa on +44 123 4567890 or pippa@zonetransfer.me when making DNS changes"
dc-office.zonetransfer.me. 7200	IN	A	143.228.181.132
deadbeef.zonetransfer.me. 7201	IN	AAAA	dead:beaf::
dr.zonetransfer.me.	300	IN	LOC	53 20 56.558 N 1 38 33.526 W 0.00m 1m 10000m 10m
DZC.zonetransfer.me.	7200	IN	TXT	"AbCdEfG"
email.zonetransfer.me.	2222	IN	NAPTR	1 1 "P" "E2U+email" "" email.zonetransfer.me.zonetransfer.me.
email.zonetransfer.me.	7200	IN	A	74.125.206.26
Hello.zonetransfer.me.	7200	IN	TXT	"Hi to Josh and all his class"
home.zonetransfer.me.	7200	IN	A	127.0.0.1
Info.zonetransfer.me.	7200	IN	TXT	"ZoneTransfer.me service provided by Robin Wood - robin@digi.ninja. See http://digi.ninja/projects/zonetransferme.php for more information."
internal.zonetransfer.me. 300	IN	NS	intns1.zonetransfer.me.
internal.zonetransfer.me. 300	IN	NS	intns2.zonetransfer.me.
intns1.zonetransfer.me.	300	IN	A	81.4.108.41
intns2.zonetransfer.me.	300	IN	A	167.88.42.94
office.zonetransfer.me.	7200	IN	A	4.23.39.254
ipv6actnow.org.zonetransfer.me.	7200 IN	AAAA	2001:67c:2e8:11::c100:1332
owa.zonetransfer.me.	7200	IN	A	207.46.197.32
robinwood.zonetransfer.me. 302	IN	TXT	"Robin Wood"
rp.zonetransfer.me.	321	IN	RP	robin.zonetransfer.me. robinwood.zonetransfer.me.
sip.zonetransfer.me.	3333	IN	NAPTR	2 3 "P" "E2U+sip" "!^.*$!sip:customer-service@zonetransfer.me!" .
sqli.zonetransfer.me.	300	IN	TXT	"' or 1=1 --"
sshock.zonetransfer.me.	7200	IN	TXT	"() { :]}; echo ShellShocked"
staging.zonetransfer.me. 7200	IN	CNAME	www.sydneyoperahouse.com.
alltcpportsopen.firewall.test.zonetransfer.me. 301 IN A	127.0.0.1
testing.zonetransfer.me. 301	IN	CNAME	www.zonetransfer.me.
vpn.zonetransfer.me.	4000	IN	A	174.36.59.154
www.zonetransfer.me.	7200	IN	A	5.196.105.14
xss.zonetransfer.me.	300	IN	TXT	"'><script>alert('Boo')</script>"
zonetransfer.me.	7200	IN	SOA	nsztm1.digi.ninja. robin.digi.ninja. 2019100801 172800 900 1209600 3600
```
</details>

