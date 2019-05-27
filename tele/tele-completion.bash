#/usr/bin/env bash

if [ -d ~/.tele ]; then
    
    acc_list_str="--help --new"
    
    for j in `ls ~/.tele`; do
        acc_list_str="$acc_list_str $j"
    done
    
    complete -W "$acc_list_str" tele
fi
