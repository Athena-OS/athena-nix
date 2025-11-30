{ pkgs, ... }:

with pkgs;

[
  ad-miner
  adenum
  aesfix
  aeskeyfind
  aflplusplus
  aiodnsbrute
  amass
  # django deps of archivebox is tagged as insecure
  # archivebox
  ares-rs
  argus
  argus-clients
  arjun
  arp-scan
  arpoison
  asleap
  asnmap
  assetfinder
  atftp
  bettercap
  bind
  bloodhound
  bloodhound-py
  # https://github.com/NixOS/nixpkgs/issues/425333
  # boofuzz
  bruteforce-luks
  brutespray
  bully
  burpsuite
  cadaver
  caido
  # cameradar # broken
  cantoolz
  certgraph
  certipy
  certsync
  cewl
  cfr
  chainsaw
  chaos
  checksec
  chipsec
  chntpw
  clair
  clairvoyance
  cloudlist
  cmospwd
  coercer
  commix
  crackle
  crackql
  crlfuzz
  crowbar
  cutter
  cutterPlugins.rz-ghidra
  dirb
  dive
  dnsenum
  dnsmasq
  dnsrecon
  dnstracer
  dnstwist
  dnsx
  dorkscout
  dsniff
  # https://github.com/NixOS/nixpkgs/issues/425350
  # dublin-traceroute
  edb
  enum4linux
  enum4linux-ng
  eresi
  etherape
  ettercap
  evil-winrm
  exabgp
  exploitdb
  fcrackzip
  feroxbuster
  ffuf
  fierce
  # https://github.com/NixOS/nixpkgs/issues/425366
  # findomain
  firewalk
  fping
  freeipmi
  freerdp
  fscan
  gau
  gdb
  gdbgui
  geoip
  ghauri
  ghdorker
  ghidra
  git-hound
  gitleaks
  go-cve-search
  gobuster
  gomapenum
  gospider
  gowitness
  # https://github.com/NixOS/nixpkgs/issues/425346
  # gpredict
  graphinder
  graphqlmap
  graphw00f
  gsocket
  hashcat
  hashcat-utils
  hashpump
  hcxdumptool
  hcxtools
  # https://github.com/NixOS/nixpkgs/issues/425348
  # hopper
  hping
  httprobe
  httpx
  iaito
  ike-scan
  iputils
  jadx
  john
  johnny
  joomscan
  # https://github.com/NixOS/nixpkgs/issues/425402
  # jpexs # It needs openjdk to be built and takes a lot of time. Probably no worth to keep
  jsbeautifier
  # https://github.com/NixOS/nixpkgs/issues/425343
  # junkie
  jwt-hack
  kalibrate-rtl
  katana
  kerbrute
  kismet
  kiterunner
  # Marked as broken
  # klee
  # https://github.com/NixOS/nixpkgs/issues/425336
  # kube-hunter
  ldapdomaindump
  ldeep
  libargon2
  # https://github.com/NixOS/nixpkgs/issues/425358
  # libtins
  ligolo-ng
  linux-exploit-suggester
  lldb
  macchanger
  # https://github.com/NixOS/nixpkgs/issues/425353
  # maigret
  mailsend
  maltego
  mapcidr
  masscan
  mdk4
  medusa
  metabigor
  metasploit
  # https://github.com/NixOS/nixpkgs/issues/425338
  # mitm6
  mitmproxy
  mitmproxy2swagger
  mongoaudit
  mtr
  mtr-gui
  # https://github.com/NixOS/nixpkgs/issues/425354
  # ncrack
  netdiscover
  netexec
  netmask
  netsniff-ng
  nfdump
  ngrep
  ngrok
  nikto
  nmap
  nosqli
  ntlmrecon
  nuclei
  onesixtyone
  osslsigncode
  ostinato
  padbuster
  pcapfix
  pdfcrack
  photon
  pixiewps
  powersploit
  proxmark3
  psudohash
  pwnat
  pwncat
  # https://github.com/NixOS/nixpkgs/issues/425357
  # python313Packages.angrop
  python313Packages.arsenic
  python313Packages.certipy-ad
  python313Packages.dnspython
  python313Packages.httpx
  python313Packages.impacket
  python313Packages.ldapdomaindump
  python313Packages.minidump
  python313Packages.minikerberos
  python313Packages.myjwt
  python313Packages.netmap
  # python313Packages.patator # marked as broken
  python313Packages.pyjsparser
  python313Packages.pypykatz
  # https://github.com/NixOS/nixpkgs/issues/425342
  # python313Packages.rfcat
  python313Packages.ropper
  python313Packages.scapy
  # https://github.com/NixOS/nixpkgs/issues/425363
  # python313Packages.scrapy
  # https://github.com/NixOS/nixpkgs/issues/308232
  # python312Packages.scrapy-deltafetch
  # python312Packages.scrapy-fake-useragent
  # python312Packages.scrapy-splash
  python313Packages.shodan
  python313Packages.spyse-python
  python313Packages.sshtunnel
  python313Packages.thefuzz
  python313Packages.torpy
  # https://github.com/NixOS/nixpkgs/issues/425365
  # python312Packages.uncompyle6
  python313Packages.websockify
  radare2
  rathole
  reaverwps-t6x
  redfang
  redsocks
  responder
  # https://github.com/NixOS/nixpkgs/issues/466575
  # retdec
  rita
  rizin
  rizinPlugins.rz-ghidra
  # https://github.com/NixOS/nixpkgs/issues/425369
  # routersploit
  shellnoob
  sherlock
  sipvicious
  smbmap
  sniffglue
  snmpcheck
  snort
  snscrape
  snyk
  soapui
  socat
  social-engineer-toolkit
  sqlmap
  ssh-mitm
  ssldump
  sslscan
  sslsplit
  stunnel
  subfinder
  # swftools # Insecure
  sysdig
  tcpdump
  tcpflow
  tcpreplay
  tcptraceroute
  tfsec
  thc-hydra
  thc-ipv6
  theharvester
  tinc
  tlsx
  tor
  traceroute
  # https://github.com/NixOS/nixpkgs/issues/425370
  # trinity
  trivy
  trufflehog
  udp2raw
  # qtwebengine deps is insecure
  # vivisect
  wafw00f
  wapiti
  websploit
  wfuzz
  whatweb
  wifite2
  wireshark
  wpscan
  wuzz
  xcat
  yersinia
  zap
  zdns
  # https://github.com/NixOS/nixpkgs/issues/425374
  # zeek
  zgrab2
  zmap
  zssh
  zulu
  # https://github.com/NixOS/nixpkgs/issues/429836
  # zzuf
  ### payloads and wordlists
  payloadsallthethings
  seclists
]
