{ pkgs, ... }:

with pkgs;

[
  _3proxy
  aircrack-ng
  airgeddon
  argus
  argus-clients
  arp-scan
  arping
  arpoison
  asnmap
  atftp
  batctl
  bettercap
  bind
  bully
  burpsuite
  cadaver
  caido
  chisel
  cntlm
  coercer
  corkscrew
  cowpatty
  creds
  darkstat
  dnschef
  dnsmasq
  driftnet
  dsniff
  # https://github.com/NixOS/nixpkgs/issues/425350
  # dublin-traceroute
  dump1090
  etherape
  ettercap
  evillimiter
  exabgp
  fping
  freeipmi
  freeradius
  geoip
  girsh
  # https://github.com/NixOS/nixpkgs/issues/425465
  # gnuradio # Too long time for building
  # https://github.com/NixOS/nixpkgs/issues/425346
  # gpredict
  # https://github.com/NixOS/nixpkgs/issues/425469
  # gqrx
  gsocket # Too long time for building
  hackrf
  hcxdumptool
  hcxtools
  hostapd-mana
  hping
  httping
  httptunnel
  i2pd
  iodine
  ipmitool
  iputils
  jnetmap
  # https://github.com/NixOS/nixpkgs/issues/425343
  # junkie
  kismet
  ldapdomaindump
  libosmocore
  # https://github.com/NixOS/nixpkgs/issues/425358
  # libtins
  ligolo-ng
  # linuxKernel.packages.linux_zen.batman_adv
  macchanger
  mailsend
  mapcidr
  mdk4
  metasploit
  mfcuk
  mfoc
  miredo
  # https://github.com/NixOS/nixpkgs/issues/425338
  # mitm6
  mitmproxy
  mitmproxy2swagger
  mtr
  mtr-gui
  mubeng
  multimon-ng
  netdiscover
  netsniff-ng
  # networkminer
  nfdump
  ngrep
  ngrok
  obfs4
  ostinato
  p0f
  pcapfix
  pixiewps
  pmacct
  proxify
  proxmark3
  proxychains-ng
  pwnat
  pwncat
  python313Packages.impacket
  python313Packages.ldapdomaindump
  python313Packages.netmap
  python313Packages.scapy
  python313Packages.sshtunnel
  python313Packages.torpy
  python313Packages.websockify
  rathole
  reaverwps-t6x
  redsocks
  responder
  rinetd
  rustcat
  samplicator
  sniffglue
  snmpcheck
  snort
  soapui
  socat
  spiped
  ssh-mitm
  sshuttle
  ssldump
  sslh
  sslscan
  sslsplit
  stacs
  stunnel
  suricata
  swaks
  tcpdump
  tcpflow
  tcpreplay
  tcptraceroute
  thc-ipv6
  tinc
  tinyproxy
  tor
  torsocks
  tshark
  udp2raw
  udpreplay
  udptunnel
  # https://github.com/NixOS/nixpkgs/issues/425439
  # urh
  wavemon
  wifite2
  wireshark
  wstunnel
  yersinia
  zap
  zdns
  # https://github.com/NixOS/nixpkgs/issues/425374
  # zeek
  zssh
  zulu
  zzuf
]
