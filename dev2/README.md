# Notes for dev2

## Fresh Install
``` git directory
mkdir -p ~/git
```

``` fzf 
git clone --depth 1 https://github.com/junegunn/fzf.git ~/git/fzf
~/git/fzf/install
```

``` ttf-intone-nerd
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts &&
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/IntelOneMono.tar.xz
tar -xvf IntelOneMono.tar.xz
fc-cache -f
rm IntelOneMono.tar.xz
```

## SSH Keys
```
ssh-keygen -t ed25519
```

 - copy public key to dev0
 - copy public key to github

## Configure Environment
``` execute setup.sh
git clone git@github.com:winnbgwrrr/dotfiles.git ~/git/dotfiles
~/git/dotfiles/setup.sh dev2
```
