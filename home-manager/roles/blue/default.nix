{ pkgs, home-manager, username, ... }:
{
  home-manager.users.${username} = { pkgs, ...}: {
    home.packages = with pkgs; [
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
        python311Packages.impacket
        recoverjpeg
        sleuthkit
        wapiti
        wireshark
        zap
    ];
  };
}