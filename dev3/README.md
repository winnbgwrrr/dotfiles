# Notes for dev3

## Fresh Install
``` pacman
sudo pacman -S vim tmux fastfetch fzf wl-clipboard ttf-intone-nerd eza
```

``` yay
yay -Sy brave-bin
```

## Configure Environment
``` execute setup.sh
mkdir -p ~/git
git clone https://github.com/winnbgwrrr/dotfiles.git ~/git/dotfiles
~/git/dotfiles/setup.sh dev3
```

## Generate SSH Key
```
ssh-keygen -t ed25519
```

## Complete Config
 - ceate ~/.ssh/config to connect to dev1
 - copy dev3 publickey to dev1
 - copy dev3 publickey to dev0
 - copy dev3 publickey to github

``` set ssh url
cd ~/git/dotfiles
git remote set-url origin git@github.com:winnbgwrrr/dotfiles.git
cd ~/git/shell-scripts
git remote set-url origin git@github.com:winnbgwrrr/shell-scripts.git
```
