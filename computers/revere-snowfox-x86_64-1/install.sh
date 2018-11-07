#!/bin/bash

echo Root password?
read root_password

echo Revere user password?
read user_password

hdd=/dev/`lsblk | grep 111.8G | cut -d ' ' -f1`

wget https://raw.github.com/chalmers-revere/opendlv.os/master/x86/get.sh
source get.sh

cp setup-available/setup-chroot-02-ptpd.sh \
   setup-available/setup-post-01-router.sh \
   setup-available/setup-post-05-docker.sh \
   setup-available/setup-post-09-socketcan.sh \
   .

sed_arg=s/hostname=.*/hostname=revere-snowfox-x86_64-1/; \  
  s/root_password=.*/root_password=${root_password}/; \
  s/user_password=.*/user_password=( ${user_password} )/; \
  s/lan_dev=.*/lan_dev=eno1/; \
  s/eth_dhcp_client_dev=.*/eth_dhcp_client_dev=( enp2s0 enp0s20u1 )/; \
  s/hdd=.*/hdd=${hdd}/; \
  s/  uefi=true/  uefi=false/
sed -i "$sed_arg" install-conf.sh


sed_arg=s/subnet=.*/subnet=10.42.42.0/; \
  s/dhcp_clients=.*/dhcp_clients=( \
  "axis-m1124-0,ac:cc:8e:84:80:3c,50", \
  "velodyne-hdl32e-0,60:76:88:20:20:01,70", \
  "cisco-ie2000_16p-0,f8:7b:20:d2:fe:40,100", \
  "meinberg-m500-0_0,ec:46:70:00:99:eb,105", \
  "meinberg-m500-0_1,00:13:95:1d:f4:b6,106", \
  "applanix-pos_lv,00:17:47:20:0d:58,80", )/
sed -i "$sed_arg" setup-post-01-router.sh

sed_arg=s/dev=.*/dev=( can0 can1 )/; \
  s/bitrate=.*/bitrate=( 500000 1000000 ) /
sed -i "$sed_arg" setup-post-09-socketcan.sh

chmod +r *.sh

source install.sh
