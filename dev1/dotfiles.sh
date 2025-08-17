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

#rm -fr "$HOME/bin"
#shared_url=''
#temp_dir="$(mktemp -d)"
#git clone $shared_url --branch sh --single-branch "$temp_dir"
#mv "$temp_dir/bin" "$HOME/bin"
#rm -fr "$temp_dir"

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

cd ~/dotfiles/dev1
#git restore .
#git checkout main && git pull &&
for d in $doftiles; do
  [ -f "$d" ] || find .. -not -path '../dev*' -name "$d" -exec cp {} . \;
done &&
  for l in *; do
    [ -h "$HOME/.$l" ] && continue
    [ "$l" = "$(basename $0)" ] && continue
    [ -f "$HOME/.$l" ] && rm "$HOME/.$l"
    #    ln -s "$HOME/dotfiles/$l" "$HOME/.$l"
    echo "ln -s $HOME/dotfiles/$l $HOME/.$l"
  done ||
  {
    echo 'dotfiles config not complete' >&2
    exit 99
  }

for c in "${!config_dirs[@]}"; do
  echo "cp $c/* ${config_dirs[$c]}/$c"
  #cp $c/* "${config_dirs[$c]/$c" ||
  #{
  #  echo 'copying config files not complete' >&2
  #  exit 98
  #}
done

exit 0
