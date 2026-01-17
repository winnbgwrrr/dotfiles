#!/usr/bin/env bash
################################################################################
# Script:   setup.sh                                                           #
# Function:                                                                    #
# Usage:    setup.sh [-h] device                                               #
#                                                                              #
# Author: Robert Winslow                                                       #
# Date written: 07-08-2025                                                     #
#                                                                              #
################################################################################
. ~/bin/common.functions

USAGE_STR='[-h] device'

_find() {
  if [ -f "$1" ]; then
    realpath "$1"
    return 0
  elif [ -f "../default/$1" ]; then
    realpath "../default/$1"
    return 0
  fi
  return 1
}

_create_symlink() {
  [ -z "$1" ] || [ -z "$2" ] && return 1
  [ -d "$1" ] && return 0
  if [ "$1" -ef "$2" ]; then
    return 0
  elif [ -f "$2" ] || [ -h "$2" ]; then
    rm "$2"
  fi
  ln -s "$1" "$2"
}

####################
# setup.sh START
####################
help=$(
  cat <<END
Program description goes here.

Usage: $(basename $0) $USAGE_STR

  -h            Print this help message

END
)

while getopts 'h' OPT; do
  case "$OPT" in
  h)
    printf '%s\n' "$help"
    exit 0
    ;;
  *)
    _usage
    ;;
  esac
done

shift $((OPTIND - 1))

if [ $# -ne 1 ]; then
  _invalid_arguments "$@"
fi

device_name="${1:?}"

declare -A config_dirs
config_dirs['sshd_config.d']='/etc/ssh'
config_dirs['share']="$HOME/.local"

if [ ! -f "$HOME/.gitconfig" ]; then
  git config --global core.editor vim
  git config --global init.defaultBranch main
  git config --global push.default current
  git config --global pull.rebase true
  read -p 'Git Configuration - Enter name: ' name
  git config --global user.name "$name"
  read -p 'Git Configuration - Enter email: ' email
  git config --global user.email "$email"
fi

cd "$HOME/git/dotfiles/$device_name" && git checkout main && git pull || exit 99

while read linkfile; do
  _create_symlink "$(_find $linkfile)" "$HOME/.$linkfile" ||
    {
      echo "Failed to create symlink for $linkfile" >&2
      exit 98
    }
done <link.files

for c in "${!config_dirs[@]}"; do
  [ -d "$c" ] || continue
  $([ -w "${config_dirs[$c]}" ] || echo 'sudo') \
    rsync -avz $c/* ${config_dirs[$c]}/$c ||
    {
      echo "Failed to sync ${config_dirs[$c]} files" >&2
      exit 97
    }
done

if [ ! -d "$HOME/bin" ]; then
  mkdir "$HOME/bin"
  cp *.sh "$HOME/bin"
  chmod 750 $HOME/bin/*.sh
  script_dir="$HOME/git/shell_scripts"
  if [ -d "$HOME/.ssh" ]; then
    script_url='git@github.com:winnbgwrrr/shell-scripts.git'
  else
    script_url='https://github.com/winnbgwrrr/shell-scripts.git'
  fi
  [ -d "$script_dir" ] || git clone "$script_url" "$script_dir"
  cd "$script_dir" && git checkout main && git pull
  $script_dir/bash/patch_bin.sh
fi

echo 'Run the following commands to complete setup:'
echo 'source ~/.bash_profile'
echo 'bind -f ~/.inputrc'

exit 0
