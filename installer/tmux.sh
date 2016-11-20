#!/bin/sh

echo "install TMUX"
brew install tmux

echo "install tmp"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "setup tmux conf"
cat << EOT > ~/.tmux.conf
# overwrite default prefix key
# set -g prefix C-a

# examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'git@github.com/user/plugin'
# set -g @plugin 'git@bitbucket.com/user/plugin'

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
EOT

