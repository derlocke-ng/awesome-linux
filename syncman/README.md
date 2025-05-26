# syncman

syncman is a CLI tool and systemd service manager for bidirectional, pair-wise syncing of folders (e.g., game saves) between multiple sources and destinations. Each sync job is defined in its own YAML file.

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
1. Place all scripts and YAML files in the same directory (e.g., `/var/home/user/Documents/GitHub/cofid`).
2. Install dependencies: `yq`, `rsync`, `inotifywait`.
3. Ensure all scripts are executable: `chmod +x syncman.sh syncjob.sh`

## Configuration
- `config.yaml`: Global settings (interval, log level, etc.)
- `<jobname>.yaml`: Each sync job, e.g.:

```yaml
name: gog_saves
sources:
  - /path/to/source1
  - /path/to/source2
destinations:
  - /path/to/dest1
  - /path/to/dest2
```
- The number of sources and destinations must match for pair-wise sync.

## Usage
- List jobs: `./syncman.sh list all --user`
- Start a job: `./syncman.sh start gog_saves --user`
- Stop a job: `./syncman.sh stop gog_saves --user`
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
