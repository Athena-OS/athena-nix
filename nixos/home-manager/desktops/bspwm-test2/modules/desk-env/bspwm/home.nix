{ pkgs, ... }:

{
    home.pointerCursor = {
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
      size = 16;
    };
  xsession = {
    enable = true;
    numlock.enable = true;

    windowManager = {
      bspwm = {
        enable = true;
	alwaysResetDesktops = true;
	startupPrograms = [
	  "$HOME/.config/polybar/launch.sh"
	  "sxhkd"
	];
	monitors = {
	  DP-0 = [ "1" "2" "3" "4" "5" "6" "7" "8" ];
	  HDMI-0 = [ "9" "10" ];
	};
	rules = {
	  "Thunar" = {
	    state = "floating";
	    center = true;
	  };
	  "Leafpad" = {
	    state = "floating";
	    center = true;
	  };
	};
	settings = {
	  border_width = 4;
	  window_gap = 12;
	  split_ratio = 0.5;
	  borderless_monocle = false;
	  gapless_monocle = false;
	  focus_follows_pointer = true;
	  normal_border_color = "#434c5e";
	  focused_border_color = "#81A1C1";
	  urgent_border_color = "#88C0D0";
	  presel_border_color = "#8FBCBB";
	  presel_feedback_color = "#B48EAD";
	};
	extraConfig = ''
	  pgrep -x feh > /dev/null || feh --bg-fill --no-fehbg ~/Pictures/wallpapers/NixOS.png ~/Pictures/wallpapers/NixOS.png &
          xrdb -q
	  xset -dpms
	  xset s off
	  xsetroot -cursor_name left_ptr
	  xdotool mousemove 3840 720
	  bspc monitor DP-0   -s HDMI-0
	'';
      };
    };
  };
}
