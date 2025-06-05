# syncman

syncman is a CLI tool for bidirectional, pair-wise syncing of folders (e.g., game saves) between multiple sources and destinations. Uses YAML config files and systemd integration.

## Features
- Manage sync jobs as systemd user or system services
- Bidirectional, pair-wise sync (source[i] <-> destination[i])  
- Newer files automatically overwrite older ones during sync
- Watches for file changes and syncs automatically
- Modular YAML config: one file per sync job
- Global settings in config.yaml
- Automatic PATH handling for user-installed tools

## Requirements
- bash
- yq (YAML processor)
- rsync
- inotifywait (from inotify-tools)
- systemd

## Sync Behavior
- **Bidirectional sync**: Changes in either source or destination are synced both ways
- **Time-based overwrites**: Newer files automatically overwrite older ones using rsync's `--update` flag
- **Non-destructive**: Files are only overwritten when a newer version exists

## Setup
1. Place all scripts and YAML files in the same directory (e.g., `/var/home/user/scripts/syncman`).
2. Install dependencies: `yq`, `rsync`, `inotifywait`.
3. Ensure all scripts are executable: `chmod +x syncman.sh syncjob.sh`

## Example

Suppose you want to sync your local game save folders with a Nextcloud directory, so that your saves are automatically backed up and available on other devices via Nextcloud.  
To do this, create a file named `example_saves.yaml` in the same directory as the syncman scripts:

```yaml
name: example_saves
sources:
  - "/var/home/user/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/Duke Nukem 2/Dosbox/SAVE"
  - "/var/home/user/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/Half-Life/echoes/SAVE"
destinations:
  - "/var/home/user/Nextcloud/game-saves/duke-nukem2"
  - "/var/home/user/Nextcloud/game-saves/hl-echoes"
```

- This will sync `/var/home/user/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/Duke Nukem 2/Dosbox/SAVE` <-> `/var/home/user/Nextcloud/game-saves/duke-nukem2`
- And `/var/home/user/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common/Half-Life/echoes/SAVE` <-> `/var/home/user/Nextcloud/game-saves/hl-echoes`
- Changes in either folder of a pair are synced both ways.

**Note:**  
- The number of sources and destinations must match.
- All paths must exist and be accessible.
- You can create as many `<jobname>.yaml` files as you need for different sync jobs.
- **If your paths contain spaces, always wrap them in quotes in your YAML files.**

## Usage

### Basic Commands
- **List available sync jobs**: `./syncman.sh list all --user`
- **Start a sync job**: `./syncman.sh start example_saves --user`
- **Stop a sync job**: `./syncman.sh stop example_saves --user`
- **Show logs for a job**: `./syncman.sh log example_saves --user`

### Service Modes
- **User services** (default): `--user` - Services run under user session
- **System services**: `--system` - Services run system-wide (requires sudo)

### Examples
```bash
# Start a job as user service (default)
./syncman.sh start example_saves --user
./syncman.sh start example_saves          # same as above

# Start a job as system service
./syncman.sh start example_saves --system

# Start all jobs
./syncman.sh start all --user

# Stop and list services
./syncman.sh stop example_saves --user
./syncman.sh list all --user
```

## Systemd Integration
- **User services**: Created in `~/.config/systemd/user/` 
- **System services**: Created in `/etc/systemd/system/` (requires sudo)
- PATH environment is automatically handled for user-installed tools

## Troubleshooting
- Ensure yq, rsync, and inotifywait are installed and accessible
- Check the log for errors
- Verify that all source and destination paths exist and are accessible

**Important Notes:**
- **Newer files overwrite older ones** - This ensures the most recent version is synced
- Default sync interval is 30 seconds (configurable in `config.yaml`)