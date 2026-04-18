# Enable hardware support while watching YouTube videos

```bash
sudo pacman -S linux-firmware
sudo pacman -S intel-media-driver

# verifiy
sudo pacman -S intel-gpu-tools
sudo intel_gpu_top

# verify with video playback
mpv --hwdec=auto video_filename
```

Notes:
- Firefox 115 (and newer) does not need to be manually configured
- the package `intel-media-driver` is suitable for broadwell and newer
