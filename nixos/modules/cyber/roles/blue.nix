{ pkgs, ... }:

with pkgs;

[
  amass
  clamav
  cryptsetup
  ddrescue
  exploitdb
  ext4magic
  extundelete
  foremost
  fwbuilder
  ghidra
  netsniff-ng
  python313Packages.impacket
  recoverjpeg
  sleuthkit
  wapiti
  wireshark
  zap
]
