# awesome-linux

A collection of Bash scripts for managing and automating tasks on Debian stable systems (Bullseye/Bookworm).

## Dependencies
- Bash shell
- Debian stable (Bullseye/Bookworm)

## Scripts

### change_ip.sh
Change your system's DHCP IP to a static IP on the first ethernet interface using `/etc/network/interfaces`.

**Usage:**
```bash
sudo ./change_ip.sh
```
Edit the variables at the top of the script to match your network settings before running.

---

### change_ssh_keys.sh
Update SSH keys for root, user, and dropbear-initramfs.

**Usage:**
```bash
sudo ./change_ssh_keys.sh
```
Edit the variables at the top of the script to set your key paths and users.

---

### create_luks_encypted_disk.sh
Create a keyfile and LUKS-encrypted partition, format it with ext4, and configure it to mount via `fstab`.

**Usage:**
```bash
sudo ./create_luks_encypted_disk.sh
```
Edit the variables at the top of the script to match your device and mount point.

---

## Notes
- Most scripts are tailored for Debian stable (Bookworm/Bullseye) and may require editing variables for your setup.
- For Bookworm, the initramfs path is `/etc/dropbear/initramfs/`; for Bullseye, it's `/etc/dropbear-initramfs/` for example.

---

## Related Tools

### [ksshgen](./ksshgen/README.md)
A bash script for creating SSH keys. Supports multiple algorithms, key sizes, and passphrase modes. Interactive or argument-based usage.

### [ksslgen](./ksslgen/README.md)
A bash script for creating self-signed SSL certificates and certificate authorities for self-hosting. Includes commands for new CA and wildcard certs.

### [select-server](./select-server/README.md)
A Bash script for selecting SSH servers/tunnels from your `~/.ssh/config` and creating a usable workflow for GNOME. Includes usage examples and config tips.

### [syncman](./syncman/README.md)
A CLI tool and systemd service manager for bidirectional, pair-wise syncing of folders (e.g., game saves) between multiple sources and destinations. Uses YAML config files and supports systemd integration.
