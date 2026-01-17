# Notes for dev1

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
```

## Generate SSH Key
```
ssh-keygen -t ed25519
```

``` set ssh url
cd ~/git/dotfiles
git remote set-url origin git@github.com:winnbgwrrr/dotfiles.git
```
