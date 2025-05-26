#!/bin/bash
# syncman.sh: Manage game save sync systemd services
# Usage: ./syncman.sh [start|stop|list] [sync_name|all] [--user|--system]
# Requires: yq, systemctl, bash
#
# Systemd unit files are generated in ~/.config/systemd/user/ or /etc/systemd/system/
#
# Example: ./syncman.sh start steam_saves --user

CONFIG_GLOBAL="$(dirname "$0")/config.yaml"
SYNC_DIR="$(dirname "$0")"

usage() {
  echo "Usage: $0 [start|stop|list] [sync_name|all] [--user|--system]"
  exit 1
}

get_unit_file() {
  local name="$1"
  local mode="$2"
  if [[ "$mode" == "--user" ]]; then
    echo "$HOME/.config/systemd/user/syncjob-${name}.service"
  else
    echo "/etc/systemd/system/syncjob-${name}.service"
  fi
}

gen_unit_file() {
  local name="$1"
  local yaml_file="$2"
  local mode="$3"
  local unit_file
  unit_file=$(get_unit_file "$name" "$mode")
  mkdir -p "$(dirname "$unit_file")"
  local abs_script_path abs_yaml_path
  abs_script_path="$(cd "$SYNC_DIR" && pwd)/syncjob.sh"
  abs_yaml_path="$(cd "$SYNC_DIR" && pwd)/${name}.yaml"
  cat > "$unit_file" <<EOF
[Unit]
Description=SyncJob for $name

[Service]
Type=simple
ExecStart=$abs_script_path $abs_yaml_path
Restart=on-failure

[Install]
WantedBy=default.target
EOF
}

list_syncs() {
  find "$SYNC_DIR" -maxdepth 1 -name '*.yaml' ! -name 'config.yaml' | xargs -n1 basename | sed 's/\.yaml$//'
}

start_sync() {
  local name="$1"
  local mode="$2"
  local yaml_file="$SYNC_DIR/${name}.yaml"
  gen_unit_file "$name" "$yaml_file" "$mode"
  if [[ "$mode" == "--user" ]]; then
    systemctl --user daemon-reload
    systemctl --user start "syncjob-${name}.service"
    systemctl --user enable "syncjob-${name}.service"
  else
    sudo systemctl daemon-reload
    sudo systemctl start "syncjob-${name}.service"
    sudo systemctl enable "syncjob-${name}.service"
  fi
}

stop_sync() {
  local name="$1"
  local mode="$2"
  if [[ "$mode" == "--user" ]]; then
    systemctl --user stop "syncjob-${name}.service"
    systemctl --user disable "syncjob-${name}.service"
  else
    sudo systemctl stop "syncjob-${name}.service"
    sudo systemctl disable "syncjob-${name}.service"
  fi
}

list_services() {
  local mode="$1"
  if [[ "$mode" == "--user" ]]; then
    systemctl --user list-units --type=service | grep syncjob-
  else
    systemctl list-units --type=service | grep syncjob-
  fi
}

# Main
if [[ $# -lt 2 ]]; then
  usage
fi

CMD="$1"
NAME="$2"
MODE="${3:---user}"

case "$CMD" in
  start)
    if [[ "$NAME" == "all" ]]; then
      for n in $(list_syncs); do start_sync "$n" "$MODE"; done
    else
      start_sync "$NAME" "$MODE"
    fi
    ;;
  stop)
    if [[ "$NAME" == "all" ]]; then
      for n in $(list_syncs); do stop_sync "$n" "$MODE"; done
    else
      stop_sync "$NAME" "$MODE"
    fi
    ;;
  list)
    list_services "$MODE"
    ;;
  *)
    usage
    ;;
esac
