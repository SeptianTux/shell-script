#!/bin/bash

echo "starting windows 8.1 virtual machine ..."
virsh start win8 &> /dev/null
if [ $? -gt 0 ]
then
    echo "windows 8.1 virtual machine is already running ..."
fi

echo "opening virt-viewer ..."
virt-viewer --domain-name win8 &> /dev/null &
echo "done ...."
