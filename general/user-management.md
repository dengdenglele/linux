## Add new user without sudo privilges
Add an additional user, stick with the defaults, will not have sudo rights:

```bash
sudo adduser username
```

## Delete a user (including home directory)

```bash
sudo deluser username

# also delete his home directory
# hint: when the user was previously logged in, the command might fail to delete the home directory, but will not tell you it failed
sudo deluser --remove-home username
```

## Allow user to perform specific commands without being explicitly in sudo group or requiring password input

```bash
$ sudo visudo

# at the bottom of the sudoers file add following lines to enable non sudo users to update and upgrade system
username ALL = NOPASSWD: /usr/bin/apt update
username ALL = NOPASSWD: /usr/bin/apt upgrade -y

# commands must be exactly performed as written in sudoers file, e.g.:
$ sudo apt update
$ sudo apt upgrade -y
```

## [Create a "guest" account with home directory in /tmp/home/guest](https://www.tutorialspoint.com/how-to-change-the-default-home-directory-of-a-user-on-linux)

Variant 1: Create a new user "guest" with home directory in /tmp/home/guest

```bash
sudo adduser guest --home /tmp/home/guest
```

Variant 2: Change the home directory for an already existing user "guest":

```bash
sudo usermod -d /tmp/home/guest guest

# erase the old home folder of user guest with rm if neccessary
```

Verify the changes:

```bash
grep guest /etc/passwd
```

The "temporary" home directory will be cleared after a reboot of the system.
