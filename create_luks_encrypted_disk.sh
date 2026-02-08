#!/bin/bash

# script to create a keyfile and create an luks encrypted disk2 (formatted with ext4)


## variables for user configuration
#keyfile path
KEYFILE="/root/.secure/.hdd1.key"
#devicename for luks
LUKS_DEVICE="hdd1"
#device
DEVICE="/dev/sdb"
#mountpoint
MOUNTPOINT="/mnt/hdd1/"

set -e

function check_root()  {
  if [[ $EUID -ne 0 ]]; then
      echo "$0 is not running as root. Please run as root or enter sudo password."
	  sudo "$0" "$(pwd)$@"
      exit $?
  fi
}

function create_keyfile ()  {
  mkdir -p /root/.secure
  dd bs=4096 count=8 if=/dev/random of=$KEYFILE iflag=fullblock
  chmod -v 0400 $KEYFILE
  chown root:root $KEYFILE
}

function encrypt_disk ()  {
  cryptsetup luksFormat $DEVICE $KEYFILE
  cryptsetup luksOpen $DEVICE $LUKS_DEVICE --key-file $KEYFILE
  mkfs.ext4 /dev/mapper/$LUKS_DEVICE
  echo "$LUKS_DEVICE $DEVICE $KEYFILE luks,discard" >> /etc/crypttab
  echo "#$LUKS_DEVICE mount" >> /etc/fstab
  echo "/dev/mapper/$LUKS_DEVICE $MOUNTPOINT ext4 defaults 0 2" >> /etc/fstab
  mkdir -p $MOUNTPOINT
}

check_root
create_keyfile
encrypt_disk