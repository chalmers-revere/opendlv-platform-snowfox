#!/bin/sh

netload=$(bmon -p enp10s0,enp11s0,enp5s0,enp4s0 -o 'format:fmt=$(element:name)%RX:%$(attr:rxrate:bytes)%TX:%$(attr:txrate:bytes)\n;quitafter=2')
ts=$(date +%s%N)
echo "${netload}" | sed -e "s/enp/${ts};enp/" | sed -e "s/%/\;/g" | grep -v "RX:;0.00;TX:;0.00"
