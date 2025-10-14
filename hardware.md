# [Undervolt Intel Core CPUs up to 9th generation](https://cryptosingh1337.medium.com/how-to-under-volt-intel-i-series-cpu-in-ubuntu-abc9283f4760)
- [Git repository](https://github.com/georgewhewell/undervolt)
- Requires python and pip
- Modern Intel CPUs starting with generation 10th and newer do not have any firmware parameters for undervolting/overclocking
- Read more about the Plundervolt vulnerability [here](https://plundervolt.com/)
- A modest starting point is to set -50 mV for each CPU, CPU cache and iGPU
- Still testing the stability of 8th Gen U-series CPU with CPU and CPU cache set to -100 mV and iGPU set to -50 mV

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.bashrc
sudo pip install undervolt --break-system-packages

cat <<EOF | sudo tee /etc/systemd/system/undervolt.service
[Unit]
Description=undervolt
After=suspend.target
After=hibernate.target
After=hybrid-sleep.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/undervolt -v --core -50 --cache -50 --gpu -50

[Install]
WantedBy=multi-user.target
WantedBy=suspend.target
WantedBy=hibernate.target
WantedBy=hybrid-sleep.target
EOF

sudo systemctl start undervolt.service
sudo systemctl enable undervolt.service
sudo undervolt --read
```


# [TLP Optimizing Guide](https://linrunner.de/tlp/support/optimizing.html)

- TLP is an optional tool for power optimization with a vast amount of settings.
- Test out if your distro is not already shipping with a good power management tool.
  - Fedora 41 with GNOME 47 is shipping with `tuned` package.
  - Other distros might ship with `power-profiles-daemon` (link below)

```bash
# use newest package from repo depending on distro (link below)
# install tlp and tlp radio device wizard
sudo apt install tlp tlp-rdw

# read optimizing guide (link below)
# and edit settings in
sudo nano /etc/tlp.d/own-tlp.conf

# apply settings
sudo tlp start

# check tlp status
tlp-stat -s ### tlp version
tlp-stat --cdiff ### difference default and user configuration
tlp-stat -c ### active configuration file and enabled parameters

# reinstall tlp with default settings
sudo apt remove tlp --purge && sudo apt install tlp

# nice GUI for beginners
flatpak install flathub com.github.d4nj1.tlpui
```
Do not disable 
- `CPU_BOOST_ON_BAT=1` and
- `CPU_HWP_DYN_BOOST_ON_BAT=1`,

otherwise Intel CPUs (8th gen?) will not get pass 800MHz when 
- `CPU_ENERGY_PERF_POLICY_ON_BAT=balance_power` is set to `balance_power`

**References**
- [Restoring TLP default settings - how?](https://www.reddit.com/r/linux4noobs/comments/yv1yim/restoring_tlp_default_settings_how/)
- [TLP: repos and installation depending on distro](https://linrunner.de/tlp/installation/index.html)
- [TLP: making changes](https://linrunner.de/tlp/settings/introduction.html#making-changes)
- [TLP: optimizing guide](https://linrunner.de/tlp/support/optimizing.html)
- [TLP: power-profiles-daemon (GNOME/KDE) vs TLP](https://linrunner.de/tlp/faq/ppd.html)

# Hardware acceleration
How to activate hardware support for video playback and energy consumption reduction

## Install non-free Intel media drivers for Gen 8+
Add the following lines to `/etc/apt/sources.list`
```bash
deb https://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian bookworm main contrib non-free non-free-firmware

deb https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware
deb-src https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware

deb https://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
deb-src https://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
```

Afterwards install the non-free drivers (free will be replaced) and reboot
```bash
sudo apt update
sudo apt install intel-media-va-driver-non-free
```
- [Debian Wiki: HardwareVideoAcceleration](https://wiki.debian.org/HardwareVideoAcceleration#VA-API)
- [Debian Wiki: SourcesList](https://wiki.debian.org/SourcesList#Example_sources.list)

## Enable hardware acceleration for mpv player
```bash
echo "hwdec=auto" >> ~/.config/mpv/mpv.conf
```
or toggle it with shortcut: `Ctrl` + `h`

show file, video and audio infos: `Shift` + `i`

**References**
- [mpv mit Hardware-Decoding](https://natenom.de/2023/07/mpv-mit-hardware-decoding/)
- [Debian Wiki: HardwareVideoAcceleration](https://wiki.debian.org/HardwareVideoAcceleration)
- [Arch Wiki: Hardware video acceleration](https://wiki.archlinux.org/title/Hardware_video_acceleration)
- [Fedora Wiki: Firefox Hardware acceleration](https://fedoraproject.org/wiki/Firefox_Hardware_acceleration)

## Disable unsupported modern codecs on Firefox
Unsupported codecs running on old devices are accelerated via software / CPU only.
This can cause high energy consumption and stuttering video playback with high video resolutions.
YouTube and other sites do not check if modern codecs are supported, so they will not fall back to older hardware-accelerated codecs.

- Install [h264ify](https://addons.mozilla.org/de/firefox/addon/h264ify/) add-on to enforce usage of supported H.264 codec on all YouTube videos
- Disable AV1 support: enter "about:config" in address bar, search for "media.av1.enabled" and set it to false

# Diagnostics

```bash
# Make sure Secure Boot is disabled, as it can interfere with hardware-related settings
mokutil --sb-state

# Monitoring GPU and usage of hardware acceleration for videos played in Firefox etc
sudo apt install intel-gpu-top
sudo intel_gpu_top

# Monitor CPU frequency, voltage settings and temperatures
sudo apt install i7z
sudo i7z

# Stress test CPU cores after undervolting / overclocking adjustments
sudo apt install stress
## stress test the cpu with 8 threads (e.g. 4 pyhsical cores + 4 virtual cores)
sudo stress --cpu 8

# btop, an even nicer looking htop
sudo apt install btop

# SSD health and TBW values
sudo apt install smartmontools
sudo smartctl -a /dev/nvme0n1

sudo apt install nvme-cli
sudo nvme smart-log /dev/nvme0n1
```

- [How to Check the Health of SSD in Linux](https://www.baeldung.com/linux/ssd-verify-health)

# Check battery health and set charging thresholds for laptops

```bash
# Check battery health
upower -i /org/freedesktop/UPower/devices/battery_BAT0
sudo upower -i $(upower -e | grep 'BAT')

# Print out current battery charging threshold
cat /sys/class/power_supply/BAT0/charge_start_threshold
cat /sys/class/power_supply/BAT0/charge_stop_threshold

# Set the charging thresholds to 75/80
echo 75 | sudo tee /sys/class/power_supply/BAT0/charge_start_threshold
echo 80 | sudo tee /sys/class/power_supply/BAT0/charge_stop_threshold
```

# Setup network interfaces in server environment
An example of the contents of the /etc/network/interfaces file:
```bash
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug enp0s31f6
iface enp0s31f6 inet dhcp
```

# Manage Logitech devices on Linux

Logitech Unifying Software for Windows is no longer available for download anymore.
Solaar is an open source alternative with GUI.

```bash
sudo apt install solaar
```

# Update firmware and BIOS with fwupd

```bash
sudo apt install fwupd
fwupdmgr get-devices
fwupdmgr refresh
fwupdmgr get-updates
fwupdmgr update
```

```bash
# downgrade BIOS, SSD etc
fwupdmgr downgrade
```

- [Arch Wiki: fwupd](https://wiki.archlinux.org/title/Fwupd)

# Gather BIOS information

```bash
mokutil --sb-state
sudo dmidecode -s system-serial-number
sudo dmidecode | grep BIOS -A 5
```
