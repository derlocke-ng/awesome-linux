# select-server

A Bash script for selecting SSH servers/tunnels and creating a usable workflow for GNOME.

## Usage
Copy `select-server` to `~/.local/bin` and run in terminal with `select-server`.

Example entries for `~/.ssh/config`:
```
## example for sftp access (sftp in docker as host, will use user:pass, example for rotating ssh keys)
# downloads@m1
Host m1-downloads
    HostName m1.kiwi
    User user
    Port 2224
    CheckHostIP no
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null

## exmaple for ssh access
# kiwi-cloud.kiwi
Host kiwi-cloud
    HostName kiwi-cloud.kiwi
    User user
    Port 2222
    IdentityFile ~/.ssh/id-rsa

## example for ssh tunnel
# Tunnel to kiwi-master - Portainer
Host kiwi-master-portainer
    HostName kiwi-master.kiwi
    User user
    Port 2222
    IdentityFile ~/.ssh/id-rsa
    LocalForward 9443 127.0.0.1:9443
```

Use `sftp://Host` for connecting to remote SSH host via Nautilus or other supported file browsers,
e.g. `sftp://m1-downdloads/Downloads m1-downloads` in `~/.config/gtk-3.0/bookmarks` to create a bookmark in Nautilus.

## Requirements
- Bash shell
- OpenSSH tools