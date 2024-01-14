{ username, ...}: {
  home-manager.users.${username} = { pkgs, ...}: {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
