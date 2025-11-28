#!/usr/bin/env bash
################################################################################
# Script:   setup.sh                                                           #
# Function:                                                                    #
# Usage:    setup.sh [-h]                                                      #
#                                                                              #
# Author: Robert Winslow                                                       #
# Date written: 07-08-2025                                                     #
#                                                                              #
################################################################################
. ~/bin/common.functions

USAGE_STR='[-h] [remote_aliases]'

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
  [ -h "$2" ] || [ -d "$1" ] && return 0
  [ -f "$2" ] && rm "$2"
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

cd "$HOME/git/dotfiles/$device_name" && git checkout main && git pull || exit 99

while read file; do
  _create_symlink "$(_find $file)" "$HOME/.$file" ||
    {
      echo "Failed to create symlink for $file" >&2
      exit 98
    }
done <file.list

if [ -f "$HOME/.config/konsolerc" ]; then
  file='konsolerc'
  _create_symlink "$(_find $file)" "$HOME/.config/$file" ||
    {
      echo "Failed to create symlink for $file" >&2
      exit 97
    }
  file="default.profile"
  _create_symlink "$(_find $file)" "$HOME/.local/share/konsole/$file" ||
    {
      echo "Failed to create symlink for $file" >&2
      exit 97
    }
fi

for c in "${!config_dirs[@]}"; do
  $([ -w "${config_dirs[$c]}" ] || echo 'sudo') cp $c/* ${config_dirs[$c]}/$c ||
    {
      echo "Failed to copy ${config_dirs[$c]} files" >&2
      exit 96
    }
done

echo 'Run the following commands to complete setup:'
echo 'source ~/.bash_profile'
echo 'bind -f ~/.inputrc'

exit 0
