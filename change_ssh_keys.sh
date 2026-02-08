#!/bin/bash

# script to change all ssh keys

# env
#local username
LOCAL_USER="USERNAME"
#public ssh key for user account
AUTHORIZED_KEYS_USER="SSH-KEY"
#public ssh key for root account
AUTHORIZED_KEYS_ROOT="SSH-KEY"
#public ssh key for preboot ssh account
AUTHORIZED_KEYS_ROOT_PREBOOT="SSH-KEY"


# check for root

if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Please run as root or enter sudo password."
	sudo "$0" "$(pwd)$@"
    exit $?
fi

# script
echo $AUTHORIZED_KEYS_USER > /home/$LOCAL_USER/.ssh/authorized_keys
chmod 0600 /home/$LOCAL_USER/.ssh/authorized_keys
chown $LOCAL_USER:$LOCAL_USER /home/$LOCAL_USER/.ssh/authorized_keys
echo $AUTHORIZED_KEYS_ROOT > /root/.ssh/authorized_keys
chmod 0600 /root/.ssh/authorized_keys
echo "no-port-forwarding,no-agent-forwarding,no-x11-forwarding $AUTHORIZED_KEYS_ROOT_PREBOOT" > /etc/dropbear/initramfs/authorized_keys

systemctl restart sshd
