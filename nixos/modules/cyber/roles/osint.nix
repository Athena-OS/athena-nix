{ pkgs, ... }:

with pkgs;

[
  ad-miner
  aiodnsbrute
  amass
  asn
  assetfinder
  bind
  bloodhound
  bloodhound-py
  cantoolz
  certgraph
  chaos
  checkpwn
  clairvoyance
  cloudlist
  dnsenum
  dnsrecon
  dnstracer
  dnstwist
  dnsx
  dorkscout
  enum4linux
  enum4linux-ng
  fierce
  # https://github.com/NixOS/nixpkgs/issues/425366
  # findomain
  fping
  gau
  geoip
  ghdorker
  git-hound
  gitleaks
  gomapenum
  gowitness
  graphinder
  holehe
  httping
  katana
  kiterunner
  knockpy
  ldeep
  linux-exploit-suggester
  # https://github.com/NixOS/nixpkgs/issues/425353
  # maigret
  maltego
  metabigor
  metasploit
  netdiscover
  netmask
  ntlmrecon
  octosuite
  parsero
  photon
  proxmark3
  python313Packages.shodan
  # https://github.com/NixOS/nixpkgs/issues/425363
  # python313Packages.scrapy
  # https://github.com/NixOS/nixpkgs/issues/308232
  # python312Packages.scrapy-deltafetch
  # python312Packages.scrapy-fake-useragent
  # python312Packages.scrapy-splash
  python313Packages.spyse-python
  rita
  sherlock
  sleuthkit
  smbmap
  sn0int
  sniffglue
  snmpcheck
  snscrape
  social-engineer-toolkit
  socialscan
  subfinder
  subjs
  thc-ipv6
  theharvester
  traceroute
  trufflehog
  uncover
  webanalyze
  websploit
  whatweb
  zgrab2
]
