#!/bin/bash

pgrep pulseeffects

if [ $? -gt 0 ]
then
    pulseeffects --gapplication-service &> /dev/null &
fi
