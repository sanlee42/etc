export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"

xscreensaver -no-splash &
sawfish &
xfce-mcs-manager
xfce4-power-manager
xfce4-session &
# xmodmap ~/etc/xmodmap >/dev/null 2>&1
exec xfdesktop
# exec startkde
# export XDG_CURRENT_DESKTOP=GNOME-Classic:GNOME
# export GNOME_SHELL_SESSION_MODE=classic
# exec gnome-session --session=gnome-classic

