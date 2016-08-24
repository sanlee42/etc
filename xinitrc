export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
export LC_CTYPE="zh_CN.UTF-8"
#xscreensaver -no-splash &
sawfish &
xfce-mcs-manager
xfce4-power-manager
xfce4-session &
xrandr  --output HDMI1   --panning 1920x1080+3840+0 --scale 2x2
exec xfdesktop
# exec startkde
