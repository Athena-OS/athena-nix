{ pkgs, ... }:

with pkgs;

[
  aflplusplus
  # archivebox # python-django dep is marked as insecure
  apachetomcatscanner
  arjun
  assetfinder
  # https://github.com/NixOS/nixpkgs/issues/425333
  # boofuzz
  brakeman
  burpsuite
  caido
  cantoolz
  chipsec
  clairvoyance
  commix
  crackql
  crlfuzz
  dalfox
  dirb
  dirstalk
  dontgo403
  doona
  feroxbuster
  ffuf
  firewalk
  gau
  ghauri
  gobuster
  gospider
  gowitness
  graphinder
  graphqlmap
  graphw00f
  hakrawler
  honggfuzz
  httpx
  interactsh
  jaeles
  joomscan
  jsbeautifier
  jwt-hack
  katana
  kiterunner
  log4j-scan
  mdk4
  metasploit
  # https://github.com/NixOS/nixpkgs/issues/425338
  # mitm6
  mitmproxy
  mitmproxy2swagger
  mongoaudit
  monsoon
  nikto
  nosqli
  nuclei
  photon
  plecost
  psudohash
  python313Packages.arsenic
  python313Packages.httpx
  python313Packages.pyjsparser
  # https://github.com/NixOS/nixpkgs/issues/425363
  # python313Packages.scrapy
  # https://github.com/NixOS/nixpkgs/issues/308232
  # python312Packages.scrapy-deltafetch
  # python312Packages.scrapy-fake-useragent
  # python312Packages.scrapy-splash
  python313Packages.thefuzz
  radamsa
  responder
  ruler
  snallygaster
  soapui
  sqlmap
  subjs
  # swftools # Insecure
  # https://github.com/NixOS/nixpkgs/issues/425370
  # trinity
  wafw00f
  wapiti
  webanalyze
  websploit
  wfuzz
  whatweb
  wpscan
  wuzz
  yersinia
  zap
  zzuf
  ### payloads and wordlists
  payloadsallthethings
  seclists
]
