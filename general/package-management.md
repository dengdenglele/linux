# [Install Flatpak](https://wiki.debian.org/Flatpak)

```bash
sudo apt install flatpak

# enable download of german and english localisation files
flatpak --user config --set languages 'en;de'

# update flatpaks will also pull missing localisation files in existing apps
flatpak update

# add flathub repo system-wide
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# add flathub repo user-only (recommended for multiple users, but takes up more space)
# must be activated for each user separately
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# verify, "Options" column should state system or user
flatpak remotes

# save list of installed apps in .md file
flatpak list > ~/installed_flatpaks.md

# display list of installed apps in .md format in (almost) correct columns, with blankspace as delimiter
cat ~/installed_flatpaks.md  | column -t -s " "
```

[Launch Flatpaks from your Linux terminal](https://opensource.com/article/21/5/launch-flatpaks-linux-terminal)

[More on flatpak options](https://askubuntu.com/questions/1078021/how-do-i-install-a-flatpak-for-a-specific-user)
[Flatpak documentation](https://docs.flatpak.org/en/latest/using-flatpak.html)

[LibreOffice in deutsch via flatpak auf US-english-System](https://www.computerbase.de/forum/threads/libreoffice-in-deutsch-via-flatpak-auf-us-english-system.2172439/)


# apt

Save list of installed .deb packages in .md file
```bash
apt list --installed > ~/installed_deb_packages.md
```

Show all packages installed from backports repo
```bash
apt list --installed | grep backports
```

Remove a package AND corresponding config files with remove and --purge (config files in home directory are left untouched)
```bash
sudo apt remove [package-name] --purge
```
[apt remove vs apt purge: What's the Difference?](https://itsfoss.com/apt-remove-purge/)

# snap

Save list of installed snap packages in .md file
```bash
snap list --all > ~/installed_snap_packages.md
```
