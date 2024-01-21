{ pkgs, username, shell, hashed, hashedRoot, ... }:
{
# Define a user account. Don't forget to change the password by ‘passwd’.
  users = {
    users.${username} = {
      shell = pkgs.${shell};
      isNormalUser = true;
      initialHashedPassword = "${hashed}";
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