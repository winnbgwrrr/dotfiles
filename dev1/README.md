# Notes for dev1

## Fresh Install
``` pacman
sudo pacman -S vim tmux fastfetch fzf wl-clipboard ttf-intone-nerd
```

## Configure Environment
``` execute setup.sh
cd
mkdir git
cd git
git clone https://github.com/winnbgwrrr/dotfiles.git dotfiles
cd dotfiles/dev1
./setup.sh
```

## SSH Server Setup

### Config Files
``` sshd_config.d
https://github.com/winnbgwrrr/dotfiles/tree/main/dev1/sshd_config.d
```

-------------------------------------------------------------------------------

### Open Port in Firewall
``` open port
grep -Po 'Port \K.*' /etc/ssh/sshd_config.d/10-sshd.conf |
xargs -I {} sudo firewall-cmd --zone=public --permanent --add-port={}/tcp &&
sudo firewall-cmd --reload
```

Comment out lines in /etc/ssh/sshd_config.d/20-force_publickey_auth.conf
``` sshd_config.sh
TODO create script to toggle password/publickey auth
```

``` start ssh service
sudo systemctl enable sshd.service
sudo systemctl start ssh.service
```

Connect from remote machines and copy public keys into dev1's authorized keys file
Uncomment lines in /etc/ssh/sshd_config.d/20-force_publickey_auth.conf
```
sudo systemctl restart sshd.service
```

## SSH Keys
```
ssh-keygen -t ed25519
```

Connect from dev0 get public key and add it to github

``` set ssh url
cd ~/git/dotfiles
git remote set-url origin git@github.com:winnbgwrrr/dotfiles.git
```
