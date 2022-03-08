#!/bin/sh
if  [[ $1 = "-o" ]]; then
    echo "Option -o turned on"
elif [[ $1 = "-a" ]]; then
    echo "Option -a turned on"
else
    echo "You did not use option -o"
fi