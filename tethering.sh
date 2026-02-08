#!/bin/bash


function check_root()  {
  if [[ $EUID -ne 0 ]]; then
      echo "$0 is not running as root. Please run as root or enter sudo password."
	  sudo "$0" "$(pwd)$@"
      exit $?
  fi
}

function apply()  {
iptables -t mangle -A PREROUTING -i enp54s0f4u1 -j TTL --ttl-set 64
}

check_root
apply
exit

