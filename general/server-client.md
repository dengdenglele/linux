# [Installing ufw and SSH on Debian-based distros](https://www.cyberciti.biz/faq/how-to-install-ssh-on-ubuntu-linux-using-apt-get/)

## Set up client software (local device) 
```bash
sudo apt install openssh-client
```

## Set up server software (remote device)
```bash
sudo apt install openssh-server
sudo systemctl enable ssh
```

## Set up firewall (ufw) on both client and server
```bash
sudo apt install ufw

# allow port 22, otherwise SSH does not work
sudo ufw allow ssh

# check if open port 22 rule was successfully added
sudo ufw show added

# activate firewall, if and only if port 22 rule was allowed in previous command
sudo ufw enable

# check again if port 22 is open AND firewall is enabled
sudo ufw status

# BONUS allow port 80 and 443, needed for http and https
sudo ufw allow http
sudo ufw allow https
```


## Background
When ufw is setup without allowing SSH aka port 22 to be open, the "ssh user@ip-address" command will not work. A message such as "ssh: connect to host 192.123.456.789 port 22: Connection timed out" will be returned after a while.

When a VPN service such as Mullvad VPN is running on the server, SSH connection from a client will fail. A message such as "ssh: connect to host 192.123.456.789 port 22: Connection timed out" will be returned after a while.

More about ssh and port 22 [here](https://www.cyberciti.biz/faq/ufw-allow-incoming-ssh-connections-from-a-specific-ip-address-subnet-on-ubuntu-debian/) and [here](https://www.cherryservers.com/blog/how-to-configure-ubuntu-firewall-with-ufw)

## SSH into a VM with OpenSSH server leads to "This host key is known by the following other names/addresses"
This happens when a VM was copied with openssh server pre-installed.
During installation OpenSSH will assign a unique ED25519 key fingerprint.
Also keys for RSA and ECDSA will be set upl

Remove and purge the current installation of openssh-server, then reinstall openssh-server:
```bash
sudo apt purge openssh-server
sudo apt autoremove --purge
sudo apt install openssh-server
```

## SSH into server still asks for user password despite pubkey already setup
This happens when the ssh-agent is not running

Activate the ssh-agent and then run ssh-add:
```bash
eval $(ssh-agent -s)
# see note below, bad style, but also works: eval `ssh-agent -s`
# Add the default SSH keys in ~/.ssh to the ssh-agent
ssh-add
# Add a specific key to the ssh-agent
ssh-add ~/.ssh/the-private-key
```

**NOTE**: Do not use \`command\` backticks for command substitution, the prefered method is $(command). See [gnu reference](https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html).

# [Log in to the SSH server and set up pubkey](https://www.cyberciti.biz/faq/how-to-disable-ssh-password-login-on-linux/)

How to Fix “Too many authentication failures” Error / override pubkey identification / force password usage:
```bash
# if following command fails due to "Too many authentication failures"
ssh username@IpAddressOfServer

# force ssh to use password instead (=disable pubkey authentication)
ssh username@IpAdressOfServer -o PubkeyAuthentication=no
```

Set up pubkey on ssh server despite "Too many authentication failures" error:
```bash
# if following command fails
ssh-copy-id -i /client/path/to/keyFile.pub username@IpAddressOfServer

# use the command again with additional parameters to enforce password authentication
ssh-copy-id -i /client/path/to/keyFile.pub -o PubkeyAuthentication=no username@IpAddressOfServer

# keep the syntax, otherwise the pubkey copy process will fail
ssh-copy-id [-f] [-n] [-i identity file] [-p port] [-o ssh_option] [user@]hostname
```

## Background
Ssh client machine will try out all available private keys stored in .ssh folder to get access to ssh server. When all of them fail (for example more than 30 private keys were used) and the server only accepts a given amount of attempts (e.g. max 3 attempts), the server will return "Too many authentication failures" and close the connection immediately. If this happens, the ssh client will also be unable to use password login.

- [Understanding ssh-copy-id command-line options](https://www.ssh.com/academy/ssh/copy-id)
- [How to Fix “SSH Too Many Authentication Failures” Error](https://www.tecmint.com/fix-ssh-too-many-authentication-failures-error/)
- [How to recover from "Too many Authentication Failures for user root"](https://serverfault.com/questions/36291/how-to-recover-from-too-many-authentication-failures-for-user-root)

## Difference between "ssh user@ip-address" and "ssh ip-address"

Using ssh without username assumes that the user you are about to log in to has the same name as the user of the host machine
```bash
ssh <ip-address>
```

Using username before the ip address explicitly tells ssh to login as this user
```bash
ssh <username>@<ip-address>
```


# Set up public key manually on ssh server

```bash
cd
mkdir .ssh
cd .ssh
vi authorized_keys
# inside autorized keys place the string from client_device_ssh.pub file
```

# [How to disable ssh password login on Linux to increase security](https://www.cyberciti.biz/faq/how-to-disable-ssh-password-login-on-linux/)

Prerequisites:
- A user account with sudo rights is available on the ssh server
- Access to the SSH server is already set up correctly with pubkey authentication enabled

Disable password authentication:
```bash
# check if following line is present in sshd_config file
grep "Include /etc/ssh/sshd_config.d/\*.conf" /etc/ssh/sshd_config

# create a new file to disable password login/enforce pubkey authentication
sudo nano /etc/ssh/sshd_config.d/disable_root_login.conf

# copy the following lines into /etc/ssh/sshd_config.d/disable_root_login.conf and save it
## rename disable_root_login.conf to disable pubkey authentication / enable password authentcation
## delete the .conf file extension is sufficient
## ChallengeResponseAuthentication is deprecated, use KbdInteractiveAuthentication instead
## see `man sshd_config` and search for /ChallengeResponseAuthentication
KbdInteractiveAuthentication no
PasswordAuthentication no
UsePAM no
PermitRootLogin no

# reload the ssh service (or completely reboot the server/computer)
sudo systemctl reload ssh
# Difference reload and restart
## reload: The reload command tells the service to re-read its configuration files without stopping the service
## restart: The restart command stops the service and then starts it again
```

Verify settings:
```bash
# try to log in as root
ssh root@ipAdressOfServer

# try to log in with password only
ssh userNameOnServer@ipAdressOfServer -o PubkeyAuthentication=no

# verify all settings at once on ssh server
sudo sshd -T | grep -E -i 'KbdInteractiveAuthentication|PasswordAuthentication|UsePAM|PermitRootLogin'
```

- [A note about troubleshooting issues](https://www.cyberciti.biz/faq/how-to-disable-ssh-password-login-on-linux/)
- [More on hardening SSH Server](https://download.asperasoft.com/download/docs/client/3.5.2/client_admin_linux/webhelp/dita/ssh_server.html)
- [Top 20 OpenSSH Server Best Security Practices](https://www.cyberciti.biz/tips/linux-unix-bsd-openssh-server-best-practices.html)

# Root account on SSH Server

Disable root account:
```bash
$ sudo passwd -l root
```

Verify root account is disabled [(forum discussion)](https://ubuntuforums.org/archive/index.php/t-1884813.html):
```bash
$ sudo passwd -S root
# Expected output: "L" after root, then root is disabled
# Undesired output: if "P" after root, then root is enabled!!!
root L yyyy-mm-dd 99999 7 -1
```

- [How to Enable and Disable Root User Account in Ubuntu](https://linuxize.com/post/how-to-enable-and-disable-root-user-account-in-ubuntu/)
- *Only for background knowledge*: [Debian: How To Enable The Root User (Login & SSH)](https://raspberrytips.com/enable-root-debian/)

# [How to Set or Change Hostname in Linux](https://linuxize.com/post/how-to-change-hostname-in-linux/)

```bash
# check current hostname
echo $HOSTNAME
hostnamectl
# change hostname
sudo hostnamectl set-hostname newHostname
# also edit the config file, change all occurences of the old hostname to the new hostname
## not doing so might lead to a warning after each command issued on the cli
sudo vi /etc/hosts
```

old school approach
```bash
sudo vi /etc/hostname
sudo vi /etc/hosts
sudo systemctl restart systemd-hostnamed ### OR reboot system
```

- [How to change hostname on Debian 12/11/10 Linux](https://www.cyberciti.biz/faq/how-to-change-hostname-on-debian-10-linux/)
- [Linux Upskill Challenge: Day 3 - Power trip!](https://linuxupskillchallenge.org/03/?h=hostname#administrative-tasks)
