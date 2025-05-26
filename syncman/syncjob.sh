#!/bin/bash
# GNU General Public License v3.0
# This script is licensed under the GNU GPL v3.0. See LICENSE file for details.

# syncjob.sh: Run a bidirectional sync for a given sync job YAML file
# Usage: ./syncjob.sh <sync_yaml_file>
# Requires: yq, inotifywait, rsync

CONFIG_GLOBAL="$(dirname \"$0\")/config.yaml"
YAML_FILE="$1"

if [[ -z "$YAML_FILE" || ! -f "$YAML_FILE" ]]; then
  echo "Usage: $0 <sync_yaml_file>"
  exit 1
fi

NAME=$(yq -r '.name' "$YAML_FILE")
mapfile -t SOURCES < <(yq -r '.sources[]' "$YAML_FILE")
mapfile -t DESTINATIONS < <(yq -r '.destinations[]' "$YAML_FILE")

if [[ ${#SOURCES[@]} -eq 0 ]]; then
  echo "[ERROR] No sources found in $YAML_FILE" >&2
  exit 2
fi
if [[ ${#DESTINATIONS[@]} -eq 0 ]]; then
  echo "[ERROR] No destinations found in $YAML_FILE" >&2
  exit 2
fi
if [[ ${#SOURCES[@]} -ne ${#DESTINATIONS[@]} ]]; then
  echo "[ERROR] Number of sources (${#SOURCES[@]}) and destinations (${#DESTINATIONS[@]}) must match in $YAML_FILE" >&2
  exit 3
fi

# Get global interval from config.yaml, fallback to 10 if not set
GLOBAL_INTERVAL=$(yq -r '.global.default_interval // 10' "$CONFIG_GLOBAL" 2>/dev/null)

# Function to sync from src to dst without deleting or overwriting
sync_one_way() {
  local src="$1"
  local dst="$2"
  rsync -av --ignore-existing --no-whole-file --inplace "$src/" "$dst/"
}

# Function to sync each source/destination pair bidirectionally
sync_bidirectional() {
  for ((i=0; i<${#SOURCES[@]}; i++)); do
    sync_one_way "${SOURCES[$i]}" "${DESTINATIONS[$i]}"
    sync_one_way "${DESTINATIONS[$i]}" "${SOURCES[$i]}"
  done
}

# Watch for changes and sync, using interval from config.yaml
timeout=${GLOBAL_INTERVAL:-10}
while true; do
  inotifywait -r -e modify,create,move,close_write,attrib,delete "${SOURCES[@]}" "${DESTINATIONS[@]}" >/dev/null 2>&1
  sync_bidirectional
  sleep "$timeout"
done
