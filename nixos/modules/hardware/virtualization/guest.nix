{ lib, config, ... }: {
  config = lib.mkIf config.athena.baseConfiguration {
    # To not change upstream! It is managed by the installer
    services = {
      spice-vdagentd.enable = lib.mkDefault false;
      qemuGuest.enable = lib.mkDefault false;
      xe-guest-utilities.enable = lib.mkDefault false;
    };

    virtualisation = {
      # VM guest additions to improve host-guest interaction
      vmware.guest.enable = lib.mkDefault true;
      hypervGuest.enable = lib.mkDefault false;
      # The VirtualBox guest additions rely on an out-of-tree kernel module
      # which lags behind kernel releases, potentially causing broken builds.
      virtualbox.guest.enable = lib.mkDefault false;
    };
  };
}
