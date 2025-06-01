# ksslgen

A bash script for creating self-signed SSL certificates for self-hosting.

## Usage

- Create new CA:
  ```bash
  ./ksslgen.sh new_ca
  ```
- Create new self-signed wildcard SSL cert:
  ```bash
  ./ksslgen.sh new_cert example.kiwi
  ```

Edit the script to settings as needed. Pre-configured for the kiwi-network setup.

## Requirements
- Bash shell
- OpenSSL
