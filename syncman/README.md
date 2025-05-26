# syncman

**syncman is a CLI tool and systemd service manager for bidirectional, pair-wise syncing of folders (e.g., game saves) between multiple sources and destinations. Each sync job is defined in its own YAML file.**

## Features
- Manage sync jobs as systemd user or system services
- Bidirectional, pair-wise sync (source[i] <-> destination[i])
- Watches for file changes and syncs automatically
- Modular YAML config: one file per sync job
- Global settings in config.yaml

## Requirements
- bash
- yq (YAML processor)
- rsync
- inotifywait (from inotify-tools)
- systemd

## Setup
1. Place all scripts and YAML files in the same directory (e.g., `/var/home/user/Documents/GitHub/syncman`).
2. Install dependencies: `yq`, `rsync`, `inotifywait`.
3. Ensure all scripts are executable: `chmod +x syncman.sh syncjob.sh`

## Example

Suppose you want to sync game save folders between your local machine, a USB drive, and a cloud folder.  
Create a file named `example_saves.yaml` in the same directory as the scripts:

```yaml
name: example_saves
sources:
  - /var/home/user/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/Duke Nukem 2/Dosbox/SAVE
  - /var/home/user/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/Half-Life/echoes/SAVE
destinations:
  - /var/home/user/Nextcloud/game-saves/duke-nukem2
  - /var/home/user/Nextcloud/game-saves/hl-echoes
```

- This will sync `/var/home/user/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/Duke Nukem 2/Dosbox/SAVE` <-> `/var/home/user/Nextcloud/game-saves/duke-nukem2`
- And `/var/home/user/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/Half-Life/echoes/SAVE` <-> `/var/home/user/Nextcloud/game-saves/hl-echoes`
- Changes in either folder of a pair are synced both ways.

**Note:**  
- The number of sources and destinations must match.
- All paths must exist and be accessible.
- You can create as many `<jobname>.yaml` files as you need for different sync jobs.

## Usage
- List jobs: `./syncman.sh list all --user`
- Start a job: `./syncman.sh start example_saves --user`
- Stop a job: `./syncman.sh stop example_saves --user`
- Start all jobs: `./syncman.sh start all --user`
- Stop all jobs: `./syncman.sh stop all --user`

## Systemd Integration
- Services are created in `~/.config/systemd/user/` (for --user) or `/etc/systemd/system/` (for --system).
- Use `systemctl --user status syncjob-<jobname>.service` to check status.

## Troubleshooting
- Ensure yq, rsync, and inotifywait are installed and in the PATH for systemd.
- Check systemd logs for error messages: `journalctl --user -u syncjob-<jobname>.service -e`

## License
MIT