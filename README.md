# awesome-linux

A collection of Bash scripts for managing and automating tasks on Debian stable systems (Bullseye/Bookworm).

## Dependencies
- Bash shell
- Debian stable (Bullseye/Bookworm)

## Available Scripts

### change_ip.sh
Change a DHCP IP address to a static IP for the first ethernet interface via `/etc/network/interfaces`.
- **Usage:**
  Edit variables as needed and run:
  ```bash
  sudo ./change_ip.sh
  ```

### change_ssh_keys.sh
Update SSH keys for root, user, and dropbear-initramfs.
- **Usage:**
  Edit variables as needed and run:
  ```bash
  sudo ./change_ssh_keys.sh
  ```

### create_luks_encypted_disk.sh
Create a keyfile and LUKS-encrypted partition, format it with ext4, and mount via `fstab`.
- **Usage:**
  Edit variables as needed and run:
  ```bash
  sudo ./create_luks_encypted_disk.sh
  ```

## Notes
- Most scripts are tailored for Debian stable and may require editing variables for your setup.
- Scripts are being updated for compatibility with the latest Debian releases.
