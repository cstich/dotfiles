# Add 4k mode to xrandr if it is not automatically detected
xrandr --newmode "3840x2160_30.00" 297.0 3840 4016 4104 4400 2160 2168 2178 2250 +hsync -vsync
xrandr --addmode DP-4 "3840x2160_30.00"
xrandr --output DP-4 --mode "3840x2160_30.00"
