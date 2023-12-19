# In XFCE module, home.nix is used to set if implementing xfce.refined or xfce.picom
{ home-manager, username, ... }:
{
    home-manager.users.${username} = { pkgs, ...}: {
        imports = [
          ./.
        ];
    athena.desktops.xfce.picom = true;
  };
}
