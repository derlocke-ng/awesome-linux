# select-server and GNOME workflow for accessing ssh servers
*bash script for selecting ssh servers/tunnels and creating a usable GNOME workflow*

## How to use:
Copy `select-server` to `~/.local/bin` and run in terminal with `select-server`.

Example entry for `~/.ssh/config`:
```
# downloads@m1
Host m1-downloads
    HostName m1.kiwi
    User user
    Port 2224
    CheckHostIP no
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
```

Use `sftp://Host` for connecting to remote SSH host via Nautilus or other supported file browsers,
e.g. `sftp://m1-downdloads m1-downloads` in `~/.config/gtk-3.0/bookmarks` to create a bookmark in Nautilus.
