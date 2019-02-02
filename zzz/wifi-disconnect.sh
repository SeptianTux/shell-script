#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please use sudo or root account!"
    exit 666
fi

killall wpa_supplicant
dhclient -x
