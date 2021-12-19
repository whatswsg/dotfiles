xrandr --output DP-2 --mode 1920x1080 --refresh 240 --right-of HDMI-0
feh --bg-scale ~/wallpaper.jpeg &
picom -b
flameshot &

./.dwm_bar.sh &

exec dwm
