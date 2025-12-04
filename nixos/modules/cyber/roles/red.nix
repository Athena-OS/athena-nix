{ pkgs, ... }:

with pkgs;

[
  adenum
  amass
  # django deps of archivebox is tagged as insecure
  # archivebox
  arp-scan
  bettercap
  bloodhound
  bloodhound-py
  # https://github.com/NixOS/nixpkgs/issues/425333
  # boofuzz
  bruteforce-luks
  brutespray
  burpsuite
  caido
  # cameradar # broken
  certipy
  certsync
  cewl
  cfr
  checksec
  clairvoyance
  coercer
  commix
  dirb
  dive
  dnsenum
  dnsmasq
  dnsrecon
  dnstracer
  dnstwist
  dnsx
  dsniff
  # https://github.com/NixOS/nixpkgs/issues/425350
  # dublin-traceroute
  edb
  enum4linux
  enum4linux-ng
  ettercap
  evil-winrm
  exploitdb
  fcrackzip
  feroxbuster
  ffuf
  fierce
  findomain
  firewalk
  fping
  freerdp
  fscan
  gau
  gdb
  gdbgui
  geoip
  ghauri
  ghidra
  git-hound
  gitleaks
  go-cve-search
  gobuster
  gomapenum
  gospider
  gowitness
  gpredict
  graphinder
  graphqlmap
  graphw00f
  hashcat
  hashcat-utils
  hashpump
  hcxdumptool
  # https://github.com/NixOS/nixpkgs/issues/425348
  # hopper
  hping
  httprobe
  httpx
  ike-scan
  john
  johnny
  # https://github.com/NixOS/nixpkgs/issues/425402
  # jpexs # It needs openjdk to be built and takes a lot of time. Probably no worth to keep
  # https://github.com/NixOS/nixpkgs/issues/425343
  # junkie
  jwt-hack
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
  # https://github.com/NixOS/nixpkgs/issues/425358
  # libtins
  ligolo-ng
  macchanger
  # pyhanko error on maigret
  # maigret
  maltego
  mapcidr
  masscan
  medusa
  metabigor
  metasploit
  # https://github.com/NixOS/nixpkgs/issues/425338
  # mitm6
  mitmproxy
  mtr
  # https://github.com/NixOS/nixpkgs/issues/425354
  netdiscover
  netexec
  netsniff-ng
  nfdump
  ngrep
  nikto
  nmap
  nosqli
  ntlmrecon
  nuclei
  pdfcrack
  powersploit
  proxmark3
  psudohash
  pwnat
  pwncat
  # https://github.com/NixOS/nixpkgs/issues/425357
  # python313Packages.angrop
  python313Packages.certipy-ad
  python313Packages.dnspython
  python313Packages.httpx
  python313Packages.impacket
  python313Packages.ldapdomaindump
  python313Packages.minidump
  python313Packages.minikerberos
  python313Packages.myjwt
  # python313Packages.patator # marked as broken
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
  python313Packages.sshtunnel
  python313Packages.thefuzz
  # https://github.com/NixOS/nixpkgs/issues/425365
  # python312Packages.uncompyle6
  radare2
  redsocks
  responder
  # https://github.com/NixOS/nixpkgs/issues/466575
  # retdec
  rita
  rizin
  rizinPlugins.rz-ghidra
  # https://github.com/NixOS/nixpkgs/issues/425369
  # routersploit
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
  tor
  traceroute
  # trinity
  trivy
  # qtwebengine deps is insecure
  # vivisect
  wafw00f
  wfuzz
  whatweb
  wifite2
  wireshark
  wpscan
  yersinia
  zap
  # https://github.com/NixOS/nixpkgs/issues/425374
  # zeek
  zgrab2
  zmap
  zssh
  # https://github.com/NixOS/nixpkgs/issues/429836
  # zzuf
  ### payloads and wordlists
  payloadsallthethings
  seclists
]
