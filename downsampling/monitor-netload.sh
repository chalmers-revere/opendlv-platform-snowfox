#!/bin/sh

bmon -p enp10s0,enp11s0,enp5s0,enp4s0 -o 'format:fmt=$(element:name)\tRX: $(attr:rxrate:bytes)\tTX: $(attr:txrate:bytes)\n;quitafter=2'
