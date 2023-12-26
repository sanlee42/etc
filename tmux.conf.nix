#--------base set--------------
set -g prefix C-j
set-window-option -g monitor-activity on # be notified when there is activity in one of your windows
bind r source-file ~/.tmux.conf
bind-key z kill-session
set-option -g renumber-windows on # renumber windows index
#--------split set------------
#choice pane
## default  bind o move
bind | split-window -h
bind - split-window -v
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
#change pane
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5
# use y to save buffer
# press C-j I to install tmux-yank
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @yank_selection 'primary'
set -g @override_copy_command 'xclip -sel clip -i'

set-option -g default-shell /home/fikgol/.nix-profile/bin/zsh
