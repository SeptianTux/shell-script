#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please use sudo or root account!"
    exit 666
fi

wpa_supplicant -iwlx14cc20181003 -c/etc/tyn_wifi.conf -B
dhclient wlx14cc20181003
