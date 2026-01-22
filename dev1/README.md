# Notes for dev1

## Fresh Install
``` pacman
sudo pacman -S vim tmux fastfetch fzf wl-clipboard ttf-intone-nerd eza jq
```

``` vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

## Configure Environment
``` execute setup.sh
mkdir -p ~/git
git clone https://github.com/winnbgwrrr/dotfiles.git ~/git/dotfiles
~/git/dotfiles/setup.sh dev1
```

### Install vimwiki
Open vim
``` install vim plug-ins
:PlugInstall
```

## Generate SSH Key
```
ssh-keygen -t ed25519
```

## SSH Server Setup

### Open Port in Firewall
``` open port
grep -Po 'Port \K.*' /etc/ssh/sshd_config.d/10-sshd.conf |
xargs -I {} sudo firewall-cmd --zone=public --permanent --add-port={}/tcp &&
sudo firewall-cmd --reload
```

``` start ssh service
sudo systemctl enable sshd.service
sudo systemctl start ssh.service
```

``` espa
espa # temporarily allows password authentication
```

From dev0:
 - copy public key to dev1's authorized keys
 - copy dev1's public key to github

``` set ssh url
cd ~/git/dotfiles
git remote set-url origin git@github.com:winnbgwrrr/dotfiles.git
```
