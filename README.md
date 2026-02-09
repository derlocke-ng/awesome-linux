# awesome-linux

A curated collection of Bash and Python scripts designed to simplify system management and task automation across diverse Linux environments, including Debian Bookworm and Trixie, Fedora Silverblue, and beyond – making a geek's life exponentially easier! 🚀🐧

## Dependencies
- Bash shell
- Debian stable (Bookworm/Trixie)

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
Edit the variables at the top of the script to set your user and public keys.

---

### create_luks_encrypted_disk.sh
Creates a keyfile and LUKS-encrypted partition, formats it with ext4, and configures it to mount via `fstab`.

**Usage:**
```bash
sudo ./create_luks_encrypted_disk.sh
```
Edit the variables at the top of the script to match your device, mount point and keyfile.

---

### tethering.sh
Sets the TTL of incoming packets to 64 on a specified network interface using `iptables`, which can help bypass tethering detection by some carriers.

**Usage:**
```bash
sudo ./tethering.sh
```
Edit the network interface name in the script (default: `enp54s0f4u1`) to match your tethering device.

---

### gzdoom
A wrapper script to launch [GZDoom](https://zdoom.org/) via Flatpak. Place it in `~/.local/bin/` to use `gzdoom` as a command, e.g. for launching mods or WADs from the terminal.

**Usage:**
```bash
gzdoom [gzdoom_args]
```
Requires the `org.zdoom.GZDoom` Flatpak to be installed.

---

### pweb
A Python script for running an HTTPS file server on a free port with auto-generated self-signed certificates. Install it into `~/.local/bin` to use it from any project directory.

**Usage:**
```bash
install -m 755 ./pweb ~/.local/bin/pweb
pweb
```
Requires `python3` and `openssl` to be installed.

---

## Notes
- Most scripts are tailored for Debian stable (Bookworm/Trixie) and may require editing variables for your setup.
- For Bookworm/Trixie, the initramfs path is `/etc/dropbear/initramfs/`; for Bullseye, it was `/etc/dropbear-initramfs/`.

---

## Related tools for all Linux distributions

### [ksshgen](./ksshgen/README.md)
A bash script for creating SSH keys. Supports multiple algorithms, key sizes, and passphrase modes. Interactive or argument-based usage.

### [ksslgen](./ksslgen/README.md)
A bash script for creating self-signed SSL certificates and certificate authorities for self-hosting. Includes commands for new CA and wildcard certs.

### [select-server](./select-server/README.md)
A Bash script for selecting SSH servers/tunnels from your `~/.ssh/config` and creating a usable workflow for GNOME. Includes usage examples and config tips.

### [syncman](./syncman/README.md)
A CLI tool for bidirectional, pair-wise syncing of folders (e.g., game saves) between multiple sources and destinations. Uses YAML config files and supports systemd integration.
