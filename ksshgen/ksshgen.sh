#!/bin/bash

# Usage:
# ./sshkeygen.sh [hostname] [algo] [bits] [passphrase_mode]
#  hostname         Hostname for key comment and file name (default: current hostname)
#  algo             Key algorithm: rsa, ed25519, ecdsa (default: ed25519)
#  bits             Key size (default: 4096 for rsa, 256 for ecdsa/ed25519)
#  passphrase_mode  Passphrase mode: prompt, random, none (default: prompt)

show_help() {
  cat <<EOF
Usage: $0 [hostname] [algo] [bits] [passphrase_mode]

Arguments:
  hostname         Hostname for key comment and file name (default: current hostname)
  algo             Key algorithm: rsa, ed25519, ecdsa (default: ed25519)
  bits             Key size (default: 4096 for rsa, 256 for ecdsa/ed25519)
  passphrase_mode  Passphrase mode: prompt, random, none (default: prompt)

Options:
  -h, --help       Show this help message and exit
EOF
}

# Check for -h or --help
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  show_help
  exit 0
fi

HOSTNAME="${1:-$(hostname)}"
ALGO="${2}"
BITS="${3}"
PASSPHRASE_MODE="${4:-prompt}"

# Interactive algo selection if not provided
if [[ -z "$ALGO" ]]; then
  echo "Select key algorithm:"
  echo "1) ed25519 (recommended)"
  echo "2) rsa"
  echo "3) ecdsa"
  read -p "Choice [1-3, default 1]: " ALGO_CHOICE
  case "$ALGO_CHOICE" in
    1|"") ALGO="ed25519" ;;
    2) ALGO="rsa" ;;
    3) ALGO="ecdsa" ;;
    *) echo "Invalid choice."; exit 1 ;;
  esac
fi

# Interactive bit size selection if not provided
if [[ -z "$BITS" ]]; then
  case "$ALGO" in
    rsa)
      echo "Select RSA key size:"
      echo "1) 2048"
      echo "2) 4096 (recommended)"
      read -p "Choice [1-2, default 2]: " RSA_CHOICE
      case "$RSA_CHOICE" in
        1) BITS=2048 ;;
        2|"") BITS=4096 ;;
        *) echo "Invalid choice."; exit 1 ;;
      esac
      ;;
    ecdsa)
      echo "Select ECDSA key size:"
      echo "1) 256"
      echo "2) 384"
      echo "3) 521"
      read -p "Choice [1-3, default 1]: " ECDSA_CHOICE
      case "$ECDSA_CHOICE" in
        1|"") BITS=256 ;;
        2) BITS=384 ;;
        3) BITS=521 ;;
        *) echo "Invalid choice."; exit 1 ;;
      esac
      ;;
    ed25519)
      BITS=256
      ;;
    *)
      BITS=""
      ;;
  esac
fi

generate_passphrase() {
  # Use a simple word list (can be replaced with a larger one)
  local WORDS=(apple banana cherry delta echo foxtrot golf hotel india juliet kilo lima mike november oscar papa quebec romeo sierra tango uniform victor whiskey xray yankee zulu)
  local w1 w2 w3
  w1=${WORDS[$RANDOM % ${#WORDS[@]}]}
  w2=${WORDS[$RANDOM % ${#WORDS[@]}]}
  w3=${WORDS[$RANDOM % ${#WORDS[@]}]}
  echo "$w1-$w2-$w3"
}

case "$PASSPHRASE_MODE" in
  prompt)
    read -s -p "Enter passphrase (leave empty for no passphrase, or type 'g' to generate one): " PASSPHRASE
    echo
    if [[ "$PASSPHRASE" == "g" ]]; then
      PASSPHRASE=$(generate_passphrase)
      echo "Generated passphrase: $PASSPHRASE"
    fi
    ;;
  random)
    PASSPHRASE=$(generate_passphrase)
    echo "Random passphrase: $PASSPHRASE"
    ;;
  none)
    PASSPHRASE=""
    ;;
  *)
    echo "Invalid passphrase mode. Use: prompt, random, or none."
    exit 1
    ;;
esac

# Validate bit size for each algorithm
case "$ALGO" in
  rsa)
    if ! [[ "$BITS" =~ ^[0-9]+$ ]] || (( BITS < 1024 )); then
      echo "Invalid bit size for RSA. Recommended: 2048 or 4096."
      exit 1
    fi
    ;;
  ecdsa)
    if [[ "$BITS" != "256" && "$BITS" != "384" && "$BITS" != "521" ]]; then
      echo "Invalid bit size for ECDSA. Allowed: 256, 384, 521."
      exit 1
    fi
    ;;
  ed25519)
    if [[ "$BITS" != "256" && -n "$BITS" ]]; then
      echo "Invalid bit size for ED25519. Only 256 is allowed or leave empty."
      exit 1
    fi
    ;;
esac

KEYFILE="${HOSTNAME}_id_${ALGO}"
# Build ssh-keygen command
if [[ "$ALGO" == "rsa" || "$ALGO" == "ecdsa" ]]; then
  ssh-keygen -t "$ALGO" -b "$BITS" -f "$KEYFILE" -C "$HOSTNAME" -N "$PASSPHRASE"
else
  ssh-keygen -t "$ALGO" -f "$KEYFILE" -C "$HOSTNAME" -N "$PASSPHRASE"
fi

echo "Private keyfile: $KEYFILE"

echo "Public keyfile:  $KEYFILE.pub"
echo "Public key:"
cat "$KEYFILE.pub"
