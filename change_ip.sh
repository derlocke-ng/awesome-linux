#!/bin/bash

## change dhcp ip automatically to static ip on the first ethernet interface (after lo)!!! -> "$ ip a" after "2:"
## or set it manually

## env
# use dhcp ip (yes) or set manually (no)
S_AUTO="yes"
# use auto interface detection? yes/no
S_AUTO_ETH="yes"
# else set interface manually
S_ETH="eth0"
# static settings
S_IP="192.168.0.100"
S_NETMASK="255.255.255.0"
S_GW="192.168.0.1"
S_DNS="192.168.0.1"

## do not touch env
# get first UP network interface
if [[ $S_AUTO_ETH = "yes" ]]; then
	ETH_DEV="$(ip a | awk '$1 == "2:" { print $2 }' | cut -d: -f1)"
else
	ETH_DEV=$S_ETH
fi

# get dhcp ip
if [[ $S_AUTO = "yes" ]]; then
	STATIC_IP="$(ip addr show $ETH_DEV  | awk '$1 == "inet" { print $2 }' | cut -d/ -f1)"
else
	STATIC_IP=$S_IP
fi

# get dhcp gateway
if [[ $S_AUTO = "yes" ]]; then
	GW_IP="$(ip r | grep default | awk '{print $3}')"
else
	GW_IP=$S_GW
fi

# netmask, change by hand if needed
S_NETMASK="255.255.255.0"
NETMASK_IP=$S_NETMASK

# get dhcp dns
if [[ $S_AUTO = "yes" ]]; then
	GW_IP="$(ip r | grep default | awk '{print $3}')"
else
	GW_IP=$S_GW
fi

if [[ $S_AUTO = "yes" ]]; then
	DNS_IP="$(grep "nameserver" /etc/resolv.conf | awk '{print $2}')"
else
	DNS_IP=$S_DNS
fi


## change the ip and restart networking
# write config to /etc/network/interfaces
cat <<EOF >/etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto $ETH_DEV
iface $ETH_DEV inet static
address $STATIC_IP
netmask $NETMASK_IP
gateway $GW_IP 
dns-nameservers $DNS_IP
EOF

# restart networking
systemctl restart networking
