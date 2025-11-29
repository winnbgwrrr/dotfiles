# Notes for dev1

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

## Configure Environment
``` execute setup.sh
cd ~/git
git clone https://github.com/winnbgwrrr/dotfiles.git dotfiles
cd dotfiles/dev2
./setup.sh
```

## SSH Keys
```
ssh-keygen -t ed25519
```

Connect to dev1 and copy public key 
Connect to dev1 from dev0 and copy public key to git hub
Delete public key from dev1

``` set ssh url
cd ~/git/dotfiles
git remote set-url origin git@github.com:winnbgwrrr/dotfiles.git
```

## Setup bin
```
[ -d "$HOME/bin" ] ||
  {
    scripts_dir="$HOME/git/shell_scripts"
    shared_url='git@github.com:winnbgwrrr/shell-scripts.git'
    [ -d "$scripts_dir" ] || git clone "$shared_url" "$scripts_dir"
    cd "$scripts_dir" && git checkout main && git pull
    mkdir "$HOME/bin"
    cp bash/* $HOME/bin
    chmod 750 $HOME/bin/*.sh
  }
```
