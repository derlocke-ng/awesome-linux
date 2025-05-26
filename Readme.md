# awesome-linux
*Various shell scripts designed to work with Debian stable.*

## change_ip.sh
*Changes (dhcp to static) IP address via `/etc/network/interfaces`.*

### How to use:
Edit variables to your liking and run with `sudo ./change_ip.sh`.

## change_ssh_keys.sh
*Changes SSH keys for root, user and dropbear-initramfs*

### How to use:
Edit variables to your liking and run with `sudo ./change_ssh_keys.sh`.


## create_luks_encypted_disk.sh
*Creates a keyfile and a LUKS partition, formats it with ext4 and mounts it via `fstab`*

### How to use:
Edit variables to your liking and run with `sudo ./create_luks_encypted_disk.sh`.


## Notes
Most scripts are old, but will be updated to work with the latest Debian stable (Bullseye -> Bookworm for now).
