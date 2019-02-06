#!/bin/sh

for i in 1 2 3 4 5 6 7; do
    ts=$(date +%s%N)
    sysload=$(ps -eo psr,pcpu,command | tr -s " " " " | grep "^ [$i]" | grep -v "\]" 2>&1 | sed -e "s/\ /\;/" | sed -e "s/\ /\;/" | sed -e "s/\ /\;/")
    echo "${sysload}" | sed -e "s/^;/${ts}\;/"
done

