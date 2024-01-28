{ pkgs, lib, home-manager, username, ... }:
{
	home-manager.users.${username} = {
	  imports = [(import ./home.nix)];
	};
    fonts.packages = with pkgs; [
      lxgw-wenkai
      (
        nerdfonts.override {
          fonts = [
            "FiraCode"
          ];
        }
      )
    ];
}
