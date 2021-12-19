#!/bin/sh
# REQUIRES FONT-AWESOME PACKAGE TO WORK PROPERLY
# sudo pacman -S ttf-font-awesome
# sudo pacman -S ttf-font-awesome
# sudo pacman -S noto-fonts
# sudo pacman -S noto-fonts-emoji
# sudo fc-cache -fv

dte(){
        dte="$(date +"%a, %b %d %R")"
        echo "$dte"
}

hdd(){
        hdd="$(df -h /home | grep dev | awk '{print$3, " "  $5}')"
        echo "  $hdd"
}

mem(){
        mem="$(free -h | awk '/Mem:/ {printf $3 " / " $2}')"
        echo "  $mem"
}

cpu() {
    read cpu a b c previdle rest < /proc/stat
      prevtotal=$((a+b+c+previdle))
        sleep 0.5
          read cpu a b c idle rest < /proc/stat
            total=$((a+b+c+idle))
              cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
                echo "  $cpu% "
}

vpn(){
        vpn="$(ip a | grep tun0 | grep inet | wc -l)"
        echo "VPN  : $vpn"
}

kernel(){
	kernel="$(uname -r | sed "s/-amd64//g")"
	echo   $kernel
}

bat() {
	battery="$(cat /sys/class/power_supply/BAT0/capacity)"
	echo " $battery %"
}

batstat() {
	bstat="$(cat /sys/class/power_supply/BAT0/status)"
	echo "$bstat"
}

netstat() {
	logfile="${XDG_CACHE_HOME:-$HOME/.cache}/netlog"
	prevdata="$(cat $logfile)"

	rxcurrent="$(( $(cat /sys/class/net/*/statistics/rx_bytes | paste -sd '+') ))"
	txcurrent="$(( $(cat /sys/class/net/*/statistics/tx_bytes | paste -sd '+') ))"

	printf "%sKiB  %sKiB\\n" \
        "  $(((rxcurrent-${prevdata%% *})/1024))" \
        "  $(((txcurrent-${prevdata##* })/1024))"

	echo "$rxcurrent $txcurrent" > "$logfile"
}

status(){
        echo "$(cpu) | $(mem) | $(kernel) | $(hdd) | $(dte)"
}


while true; do
	xsetroot -name "$(status)"
	sleep 10s 
done
