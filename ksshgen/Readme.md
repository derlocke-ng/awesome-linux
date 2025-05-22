# ksshgen
*bash script for creating ssh keys.*

## How to use:

Run `./ksshgen.sh [hostname] [algo] [bits] [passphrase_mode]`.
```
  hostname         Hostname for key comment and file name (default: current hostname)
  algo             Key algorithm: rsa, ed25519, ecdsa (default: ed25519)
  bits             Key size (default: 4096 for rsa, 256 for ecdsa/ed25519)
  passphrase_mode  Passphrase mode: prompt, random, none (default: prompt)
```
Without any attributes you will be prompted.
