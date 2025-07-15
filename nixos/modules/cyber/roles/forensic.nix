{ pkgs, ... }:

with pkgs;

[
  acquire
  aesfix
  aeskeyfind
  afflib
  autopsy
  bmap-tools
  bulk_extractor
  chainsaw
  chipsec
  chkrootkit
  chntpw
  dc3dd
  dcfldd
  ddrescue
  dmg2img
  exiftool
  fatcat
  file
  firefox_decrypt
  foremost
  hstsparser
  libewf
  libpst
  mac-robber
  # https://github.com/NixOS/nixpkgs/issues/425426
  # mdbtools
  ms-sys
  # networkminer
  ntfs3g
  oletools
  osquery
  pdf-parser
  pev
  pngcheck
  prowler
  recoverjpeg
  regripper
  safecopy
  scalpel
  sleuthkit
  snort
  tell-me-your-secrets
  testdisk
  tracee
  usbrip
  volatility3
]
