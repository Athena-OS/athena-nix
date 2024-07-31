{ pkgs, config, ... }:
{
  users.users.${config.athena-nix.homeManagerUser} = {
    extraGroups = [ "audio" ];
  };
  # Sound settings
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  environment.systemPackages = with pkgs; [ pulseaudio ];
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
}
