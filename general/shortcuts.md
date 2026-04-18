# Create custom shortcuts with visudo and "GNOME Keyboard Shortcuts"

## Shortcuts for commands requiring sudo: shutdown, reboot and systemctl suspend

Open sudoers file with visudo
```bash
sudo visudo
```

Enter the following lines in sudoers file and save it:
```bash
# custom stuff
userName ALL = NOPASSWD: /usr/sbin/reboot
userName ALL = NOPASSWD: /usr/sbin/shutdown -h now
userName ALL = NOPASSWD: /usr/bin/systemctl suspend
```

In GNOME Desktop environment open "Settings" > "Keyboard" > "View and Customize Shortcuts" > Custom Shortcuts
- For reboot shortcut create the following:
  - Name: reboot
  - Command: sudo reboot
  - Shortcut: Ctrl + Alt + R
- For shutdown shortcut create the following:
  - Name: shutdown
  - Command: sudo shutdown -h now
  - Shortcut: Ctrl + Alt + P
- For suspend shortcut create the following:
  - Name: suspend
  - Command: sudo systemctl suspend
  - Shortcut: Ctrl + Alt + S
