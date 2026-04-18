# Make default Ubuntu extensions better

```bash
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 64
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false

gsettings set org.gnome.shell.extensions.ding icon-size 'large'
gsettings set org.gnome.shell.extensions.ding start-corner 'top-left'
gsettings set org.gnome.shell.extensions.ding show-home false
```

# Or just disable all of them

```bash
gnome-extensions disable ding@rastersoft.com
gnome-extensions disable tiling-assistant@ubuntu.com
gnome-extensions disable ubuntu-appindicators@ubuntu.com
gnome-extensions disable ubuntu-dock@ubuntu.com
```

## If tiling-assistant is disabled, set shortcuts for maximize/restore window (by default not set in Ubuntu 24.04)

```bash
# gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']" # disabling tiling-assistant is sufficient
# gsettings set org.gnome.desktop.wm.keybindings unmaximize "['<Super>Down']" # disabling tiling-assistant is sufficient
```
