{ pkgs, ... }:

{
  services = {
    sxhkd ={
      enable = true;
      keybindings = {
        "super + Return"                        = "kitty";
        "super + {_,shift + }e"                 = "{_,doas} thunar";
	"super + {_,shift + }r"			= "{_,doas} leafpad";
        "super + v"                             = "vivaldi";
        "ctrl + alt + a"                        = "flameshot gui";
        "Print"                                 = "flameshot screen -p $HOME/Pictures/flameshots";
        "super + space"                         = "rofi -show drun -theme $HOME/.config/rofi/nord.rasi";
        "super + Escape"                        = "pkill -USR1 -x sxhkd";
        "super + alt + {q,r}"                   = "bspc {quit,wm -r}";
        "super + {_,shift + }q"                 = "bspc node -{c,k}";
        "super + m"                             = "bspc desktop -l next";
        "super + y"                             = "bspc node newest.marked.local -n newest.!automatic.local";
        "super + g"                             = "bspc node -s biggest.window";
        "super + {t,shift + t,s,f}"             = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
        "super + ctrl + {m,x,y,z}"              = "bspc node -g {marked,locked,sticky,private}";
        "super + {_,shift + }{h,j,k,l}"         = "bspc node -{f,s} {west,south,north,east}";
        "super + {p,b,comma,period}"            = "bspc node -f @{parent,brother,first,second}";
        "super + {_,shift + }c"                 = "bspc node -f {next,prev}.local.!hidden.window";
        "super + {_,shift + }{i,o}"             = "bspc {desktop -f,node -d} {prev,next}.local";
        "alt + Tab"                             = "bspc desktop -f last";
        "super + Tab"                           = "bspc node -f last.local";
        "super + {_,shift + }{1-9,0}"           = "bspc {desktop -f,node -d} '^{1-9,10}'";
        "super + ctrl + {h,j,k,l}"              = "bspc node -p {west,south,north,east}";
        "super + ctrl + {1-9}"                  = "bspc node -o 0.{1-9}";
        "super + ctrl + space"                  = "bspc node -p cancel";
        "super + ctrl + shift + space"          = "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";
        "super + alt + {h,j,k,l}"               = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
        "super + alt + shift + {h,j,k,l}"       = "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
      };
    };
  };
}
