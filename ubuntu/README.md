# ubuntu-setup
remove all the bloat (aka snap), disable extensions and make Ubuntu lean again

## Install iso with dd
```bash
sudo dd if=/home/user/Downloads/ubuntu-24.04.1-desktop-amd64.iso of=/dev/sda bs=1M status=progress
```
## Ubuntu 24.04 LTS graphical installer crashes
- Installer unable to start or suddendly crashes at any time
- Set the resolution lower than the recommended one
- Happened with HP T640 in combination with LG 34WQ75X-B, set 3440x1440 to 1024x768
- Reddit: [24.04 installer keeps crashing](https://www.reddit.com/r/Ubuntu/comments/1cd6tkg/2404_installer_keeps_crashing/)

## Make Ubuntu 24.04 LTS minimal (default) installation even smaller
```bash
sudo apt remove gnome-characters yelp -y
```

## Reset admin password in Ubuntu
- Only encrypted drive is effective against this method
- [How do I reset a lost administrative password?](https://askubuntu.com/questions/24006/how-do-i-reset-a-lost-administrative-password)

## Enable AV1 support on YouTube with supported Intel GPUs
```bash
sudo apt install intel-media-va-driver-non-free
```

## 20 years of Ubuntu
- [20 Jahre Ubuntu Linux: Ein Streifzug durch zwei Linux-Jahrzehnte | c’t uplink](https://www.youtube.com/watch?v=l07l2aHEWtc)
- [Complete history of Ubuntu: a lot of highs, a lot of lows](https://www.youtube.com/watch?v=AEc-GE9n_V4)
