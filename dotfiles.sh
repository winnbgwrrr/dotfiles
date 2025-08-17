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
help=$(cat <<END
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

shift $((OPTIND-1))

if [ $# -ne 0 ]; then
  _invalid_arguments "$@"
fi

scripts=$(cat <<EOF
EOF
)

rm -fr "$HOME/bin"
shared_url=''
temp_dir="$(mktemp -d)"
git clone $shared_url --branch sh --single-branch "$temp_dir"
mv "$temp_dir/bin" "$HOME/bin"
rm -fr "$temp_dir"
find $HOME/bin -type f -not -name 'common.functions' \
  $(printf ' -not -name %s' $scripts) -delete
find $HOME/bin -type l -delete

cd ~/dotfiles
git restore .
git checkout main && git pull

sed -i '/knight.ascii/d' tmux.conf
sed -i '/workspaces/d' bashrc
sed -i 's/desert/evening/' vimrc
sed -i 's/223m/153m/;s/203m/204m/;s/195m/185m/g' bash_profile
sed -i '/setup_workspace.sh/d' bash_aliases
sed -i '/# Workspaces/,/^$/d' bash_aliases
sed -i '/# Remote/,/^$/d' bash_aliases

for l in *; do
  [ -h "$HOME/.$l" ] && continue
  [ "$l" = "$(basename $0)" ] && continue
  [ "${l##*.}" = 'aliases' ] && continue
  [ -f "$HOME/.$l" ] && rm "$HOME/.$l"
  ln -s "$HOME/dotfiles/$l" "$HOME/.$l"
done

exit 0
