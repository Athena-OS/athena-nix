#!/bin/sh

bspc desktop -f '^6'
qjackctl -a $HOME/Music/jack-pathbays/ardour.xml &
sleep 0.5
bspc desktop -f '^7'
kitty pulsemixer &
sleep 0.5
bspc desktop -f '^8'
ardour6 &
sleep 0.5
