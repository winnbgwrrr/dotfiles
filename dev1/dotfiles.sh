#!/usr/bin/env bash
################################################################################
# Script:   dotfiles.sh                                                        #
# Function:                                                                    #
# Usage:    dotfiles.sh [-h]                                                   #
#                                                                              #
# Author: Robert Winslow                                                       #
# Date written: 07-08-2025                                                     #
#                                                                              #
################################################################################
. ~/bin/common.functions

USAGE_STR='[-h] [remote_aliases]'

####################
# dotfiles.sh START
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

if [ $# -ne 0 ]; then
  _invalid_arguments "$@"
fi

declare -A config_dirs
config_dirs['hypr']="$HOME/.config"
config_dirs['sshd_config.d']='/etc/ssh'
git_dir="$HOME/git"
dotfiles_dir="$git_dir/dotfiles"
scripts_dir="$git_dir/shell_scripts"

rm -fr "$HOME/bin"
shared_url='git@github.com:winnbgwrrr/shell-scripts.git'
[ -d "$scripts_dir" ] || git clone "$shared_url" "$scripts_dir"
cd "$scripts_dir" && git checkout main && git pull
cp "$scripts_dir/patch_bin.sh" "$HOME/bin"
$HOME/bin/patch_bin.sh

dotfiles=$(
  cat <<EOF
bash_profile
bashrc
bash_aliases
bash_functions
inputrc
vimrc
tmux.conf
EOF
)

cd "$dotfiles_dir/dev1" && git restore . && git checkout main && git pull ||
  exit 99

for d in $doftiles; do
  [ -f "$d" ] || find .. -not -path '../dev*' -name "$d" -exec cp {} . \; ||
    {
      echo "unable to find/copy $d" >&2
      exit 98
    }

done

for l in *; do
  [ -h "$HOME/.$l" ] && continue
  [ "$l" = "$(basename $0)" ] && continue
  [ -f "$HOME/.$l" ] && rm "$HOME/.$l"
  ln -s "$dotfiles_dir/dev1/$l" "$HOME/.$l" ||
    {
      echo 'dotfiles config not complete' >&2
      exit 97
    }
done

for c in "${!config_dirs[@]}"; do
  cp "$c/*" "${config_dirs[$c]}/$c" ||
    {
      echo 'copying config files not complete' >&2
      exit 96
    }
done

exit 0