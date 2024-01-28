#!/usr/bin/env bash


hacktheboxip(){
htbip=$(ip addr | grep tun0 | grep inet | grep 10. | tr -s " " | cut -d " " -f 3 | cut -d "/" -f 1)

if [[ $htbip == *"10."* ]]
then
   echo "$htbip"
else
   echo ""
fi
}

# Script to check tun0 interface
if ip addr show tun0 &> /dev/null; then
    # checking if tun0 has an IP address
    if ip addr show tun0 | grep 'inet ' &> /dev/null; then
        echo "󰅵 Hackthebox IP: $(hacktheboxip) "
 
    else
        echo "HTB connecting..."
    fi 
else
    echo "󱘖 HTB Disconnected"
fi


