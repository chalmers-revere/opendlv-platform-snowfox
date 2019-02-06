#!/bin/sh

for i in 1 2 3 4 5 6 7; do ps -eo psr,pcpu,command | tr -s " " | grep "^ [$i]" | grep -v "\]"; done

