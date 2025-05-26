# ksshgen

A bash script for creating SSH keys.

## Usage

```bash
./ksshgen.sh [hostname] [algo] [bits] [passphrase_mode]
```

- `hostname`: Hostname for key comment and file name (default: current hostname)
- `algo`: Key algorithm: rsa, ed25519, ecdsa (default: ed25519)
- `bits`: Key size (default: 4096 for rsa, 256 for ecdsa/ed25519)
- `passphrase_mode`: Passphrase mode: prompt, random, none (default: prompt)

If no arguments are provided, you will be prompted for input.

## Requirements
- Bash shell
- OpenSSH tools
