# background

- [Theory: Cursor keys belong at the center of your keyboard, DEPRECATED due to Xorg](https://tonsky.me/blog/cursor-keys/)
- TL;DR: Remap CapsLock + IJKL (or WASD) to act as arrow keys
- [Mapping Caps-Lock to Esc is life changing](https://www.reddit.com/r/vim/comments/1442ads/mapping_capslock_to_esc_is_life_changing/)
  
# setup 60% keyboard

- [Install keyd (wayland) from source](https://github.com/rvaiya/keyd):

``` bash
# preparations: verify headers and install gcc
apt list --installed | grep headers
sudo apt install build-essential

# install from source
git clone https://github.com/rvaiya/keyd
cd keyd

# change branch to a "release" release version for better stability
git checkout v2.5.0 # or newer

make && sudo make install
sudo systemctl enable --now keyd

# sudo systemctl enable keyd && sudo systemctl start keyd # 

# create .conf file...
sudo nano /etc/keyd/default.conf

# ... or copy the old "default.conf" into /etc/keyd
# My config file can be found in directory "keyd_config_file"
sudo cp /path/to/keyd_config_file/default.conf /etc/keyd/default.conf

# reload the new config set
sudo keyd reload

# for more infos check out
man keyd
```

- [Use the "sample config" for capslock=overload(symbols, esc)](https://github.com/rvaiya/keyd)
- [Remap j, k, l, i to left, down, right, up. EXAMPLE](https://foosel.net/til/how-to-remap-keys-under-linux-and-wayland/)

## setup virtual keyboard mouse with keyd
- Enable "Mouse Keys" in "GNOME Settings" > "Accessibility" > "Pointing & Clicking"
- [Use gsettings to change the speed parameters keys.](https://askubuntu.com/questions/195000/mouse-arrow-moving-slowly-using-keyboard-keys/1234995#1234995)
- my parameters:

    ``` bash
    # print out current settings:
    $ gsettings list-recursively | grep keyboard | grep mouse

    # output:
    org.gnome.desktop.a11y.keyboard mousekeys-accel-time 1500
    org.gnome.desktop.a11y.keyboard mousekeys-enable true
    org.gnome.desktop.a11y.keyboard mousekeys-init-delay 10
    org.gnome.desktop.a11y.keyboard mousekeys-max-speed 3000

    
    # set these parameters:
    gsettings set org.gnome.desktop.a11y.keyboard mousekeys-accel-time 1500
    gsettings set org.gnome.desktop.a11y.keyboard mousekeys-enable true
    gsettings set org.gnome.desktop.a11y.keyboard mousekeys-init-delay 10
    gsettings set org.gnome.desktop.a11y.keyboard mousekeys-max-speed 3000
    ```



    
