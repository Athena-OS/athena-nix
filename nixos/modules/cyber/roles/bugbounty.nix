{ pkgs, ... }:

with pkgs;

[
  amass
  arjun
  assetfinder
  burpsuite
  caido
  cewl
  chaos
  commix
  crlfuzz
  crunch
  dalfox
  detect-secrets
  dirb
  dirstalk
  dnsx
  exploitdb
  feroxbuster
  ffuf
  # https://github.com/NixOS/nixpkgs/issues/425366
  # findomain
  gau
  gitleaks
  gobuster
  gospider
  gowitness
  graphqlmap
  hakrawler
  httpx
  jaeles
  joomscan
  jwt-hack
  knockpy
  masscan
  metasploit
  naabu
  nikto
  nmap
  nosqli
  nuclei
  psudohash
  pwncat
  python313Packages.httpx
  # python313Packages.patator # marked as broken
  rustscan
  sqlmap
  subfinder
  thc-hydra
  theharvester
  trufflehog
  wafw00f
  webanalyze
  wfuzz
  whatweb
  whispers
  wpscan
  ### payloads and wordlists
  payloadsallthethings
  seclists
]
