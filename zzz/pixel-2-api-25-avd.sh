#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    /opt/android-sdk/tools/emulator -avd Pixel_2_API_25 &> /dev/null &
    #emulator -avd Pixel_2_API_25 --dns-server 8.8.8.8,8.8.4.4
else
    echo "Please use normal user!"
    exit 666
fi
