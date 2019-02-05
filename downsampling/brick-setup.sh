#!/bin/sh

sudo ethtool --set-eee enp4s0 eee off
sudo ethtool --set-eee enp5s0 eee off
sudo ethtool --set-eee enp10s0 eee off
sudo ethtool --set-eee enp11s0 eee off

sudo ip link set lo multicast on
sudo ip link set enp4s0 multicast off
sudo ip link set enp5s0 multicast off
sudo ip link set enp10s0 multicast on
sudo ip link set enp11s0 multicast off

sudo route add -net 224.0.0.0 netmask 240.0.0.0 dev enp10s0
sudo route add -net 224.0.0.0 netmask 240.0.0.0 dev lo
sudo route add -net 225.0.0.109 netmask 255.255.255.255 dev enp10s0
sudo route add -net 225.0.0.111 netmask 255.255.255.255 dev lo
