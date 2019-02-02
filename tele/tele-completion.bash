#/usr/bin/env bash

if [ -d ~/.telegram ]; then
    
    acc_list_str="--help --new"
    
    for j in `ls ~/.telegram`; do
        acc_list_str="$acc_list_str $j"
    done
    
    complete -W "$acc_list_str" tele
fi
