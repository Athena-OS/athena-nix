{ pkgs, ... }:

with pkgs;

[
  aesfix
  aeskeyfind
  aespipe
  ares-rs
  asleap
  bkcrack
  bruteforce-luks
  brutespray
  bully
  cewl
  chntpw
  cmospwd
  cowpatty
  crackle
  crackql
  crowbar
  dislocker
  fcrackzip
  gnutls
  gomapenum
  hash_extender
  hash-identifier
  hashcat
  hashdeep
  hashpump
  hashrat
  hcxtools
  john
  johnny
  jwt-hack
  katana
  kerbrute
  libargon2
  libbde
  libgcrypt
  medusa
  mfoc
  # https://github.com/NixOS/nixpkgs/issues/425354
  # ncrack
  onesixtyone
  pdfcrack
  phrasendrescher
  pixiewps
  psudohash
  python313Packages.myjwt
  # python313Packages.patator # marked as broken
  python313Packages.pypykatz
  rarcrack
  reaverwps-t6x
  sha1collisiondetection
  snow
  spiped
  ssdeep
  sslscan
  testssl
  thc-hydra
  truecrack
  veracrypt
  wifite2
  xortool
  ### payloads and wordlists
  payloadsallthethings
  seclists
]
