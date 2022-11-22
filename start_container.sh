#!/bin/bash

interface='docker0' #'br0'
ipAddress='192.168.0.247'

pihole_volume='/home/richy/pihole/vpihole' #'/mnt/user/appdata/pihole-dot-doh/pihole/'
dnsmasq_volume='/home/richy/pihole/vdnsmasq' #'/mnt/user/appdata/pihole-dot-doh/dnsmasq.d/'
config_volume='/home/richy/pihole/vconfig' #'/mnt/user/appdata/pihole-dot-doh/config/'


 docker build -t richy1989/pihole-dot-doh .

#-d / -it

docker run -it \
    --name='pihole-dot-doh' \
    --cap-add=NET_ADMIN \
    --restart=unless-stopped \
    --net='bridge' \
    -e TZ="Europe/London" \
    -e HOST_OS="Unraid" \
    -v $pihole_volume:'/etc/pihole/':'rw' \
    -v $dnsmasq_volume:'/etc/dnsmasq.d/':'rw' \
    -v $config_volume:'/config':'rw' \
    -e 'DNS1'='127.1.1.1#5153' \
    -e 'DNS2'='127.2.2.2#5253' \
    -e 'TZ'='Europe/London' \
    -e 'WEBPASSWORD'='password' \
    -e 'INTERFACE'=$interface \
    -e 'ServerIP'=$ipAddress \
    -e 'ServerIPv6'='' \
    -e 'IPv6'='False' \
    -e 'DNSMASQ_LISTENING'='all' \
    -p '10053:53/tcp' \
    -p '10053:53/udp' \
    -p '10067:67/udp' \
    -p '10080:80/tcp' \
    -p '10443:443/tcp' \
    'richy1989/pihole-dot-doh:latest'