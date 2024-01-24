{ pkgs, username, shell, hashed, hashedRoot, ... }:
{
  users = {
    mutableUsers = false;
    users.${username} = {  
      shell = pkgs.${shell};
      isNormalUser = true;
      hashedPassword = "${hashed}";
      extraGroups = [ "wheel" "input" "video" "render" "networkmanager" ];
      packages = with pkgs; [
        git
        wget
      #  thunderbird
      ];
    };
    extraUsers = {
       root = {
         hashedPassword = "${hashedRoot}";
       };
     };
  };
}
