{ pkgs, ... }:

with pkgs;

[
  _3proxy
  ad-miner
  adenum
  aesfix
  aeskeyfind
  aflplusplus
  aiodnsbrute
  amass
  apache-users
  apachetomcatscanner
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
  bkcrack
  bloodhound
  bloodhound-py
  # https://github.com/NixOS/nixpkgs/issues/425333
  # boofuzz
  braa
  brakeman
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
  corkscrew
  cowpatty
  crackle
  crackql
  creds
  crlfuzz
  crowbar
  ctypes_sh
  cutter
  cutterPlugins.rz-ghidra
  dalfox
  darkstat
  davtest
  dirb
  dirstalk
  dive
  dnsenum
  dnsmasq
  dnsrecon
  dnstracer
  dnstwist
  dnsx
  dontgo403
  doona
  dorkscout
  driftnet
  dsniff
  # https://github.com/NixOS/nixpkgs/issues/425350
  # dublin-traceroute
  dump1090
  edb
  enum4linux
  enum4linux-ng
  eresi
  etherape
  ettercap
  evillimiter
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
  flasm
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
  girsh
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
  grype
  gsocket
  hakrawler
  hashcat
  hashcat-utils
  hashpump
  hcxdumptool
  hcxtools
  holehe
  honggfuzz
  # https://github.com/NixOS/nixpkgs/issues/425348
  # hopper
  hping
  httping
  httprobe
  httpx
  i2pd
  iaito
  ike-scan
  interactsh
  ipmitool
  iputils
  jadx
  jaeles
  jnetmap
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
  klee
  knockpy
  # https://github.com/NixOS/nixpkgs/issues/425336
  # kube-hunter
  ldapdomaindump
  ldeep
  libargon2
  libpst
  # https://github.com/NixOS/nixpkgs/issues/425358
  # libtins
  ligolo-ng
  linux-exploit-suggester
  lldb
  log4j-scan
  lynis
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
  mfoc
  # https://github.com/NixOS/nixpkgs/issues/425338
  # mitm6
  mitmproxy
  mitmproxy2swagger
  mongoaudit
  monsoon
  mtr
  mtr-gui
  naabu
  nbtscanner
  # https://github.com/NixOS/nixpkgs/issues/425354
  # ncrack
  netdiscover
  netexec
  netmask
  netsniff-ng
  #networkminer
  nfdump
  ngrep
  ngrok
  nikto
  nmap
  nosqli
  ntlmrecon
  nuclei
  obfs4
  onesixtyone
  osslsigncode
  ostinato
  p0f
  padbuster
  parsero
  pcapfix
  pdfcrack
  pe-bear
  photon
  phrasendrescher
  pixiewps
  plecost
  powersploit
  pmacct
  procyon
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
  python313Packages.ropgadget
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
  radamsa
  radare2
  rarcrack
  rathole
  reaverwps-t6x
  redfang
  redsocks
  responder
  retdec
  rinetd
  rita
  rizin
  rizinPlugins.rz-ghidra
  ropgadget
  # https://github.com/NixOS/nixpkgs/issues/425369
  # routersploit
  ruler
  rustcat
  rustscan
  saleae-logic
  saleae-logic-2
  samplicator
  seclists
  shellnoob
  sherlock
  sipvicious
  slither-analyzer
  smbmap
  snallygaster
  sniffglue
  snmpcheck
  snort
  snowman
  snscrape
  snyk
  soapui
  socat
  social-engineer-toolkit
  socialscan
  spiped
  sqlmap
  ssh-audit
  ssh-mitm
  sshocker
  sshuttle
  ssldump
  sslh
  sslscan
  sslsplit
  stacs
  stunnel
  subfinder
  subjs
  swaks
  # swftools # Insecure
  sysdig
  tcpdump
  tcpflow
  tcpreplay
  tcptraceroute
  testssl
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
  udptunnel
  uncover
  vivisect
  wafw00f
  wapiti
  webanalyze
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
