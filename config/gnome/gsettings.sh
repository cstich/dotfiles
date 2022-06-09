# Use this shell script to set all the options for dconf
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false

# Have nautilus/file dialogs display folders first
gsettings set org.gtk.Settings.FileChooser sort-directories-first true

# Material Shell settings
dconf write /org/gnome/shell/extensions/materialshell/bindings/previous-window "['<Super>h']"
dconf write /org/gnome/shell/extensions/materialshell/bindings/next-workspace "['<Super>j']"
dconf write /org/gnome/shell/extensions/materialshell/bindings/previous-workspace "['<Super>k']"
dconf write /org/gnome/shell/extensions/materialshell/bindings/next-window "['<Super>l']"

dconf write /org/gnome/shell/extensions/materialshell/bindings/move-window-left "['<Super><Shift>h']"
dconf write /org/gnome/shell/extensions/materialshell/bindings/move-window-bottom "['<Super><Shift>j']"
dconf write /org/gnome/shell/extensions/materialshell/bindings/move-window-top "['<Super><Shift>k']"
dconf write /org/gnome/shell/extensions/materialshell/bindings/move-window-right "['<Super><Shift>l']"

dconf write /org/gnome/shell/extensions/materialshell/bindings/resize-window-left "['<Super><Ctrl>h']"
dconf write /org/gnome/shell/extensions/materialshell/bindings/resize-window-down "['<Super><Ctrl>j']"
dconf write /org/gnome/shell/extensions/materialshell/bindings/resize-window-up "['<Super><Ctrl>k']"
dconf write /org/gnome/shell/extensions/materialshell/bindings/resize-window-right "['<Super><Ctrl>l']"

gsettings set org.gnome.desktop.wm.keybindings minimize "[]"

gsettings set org.gnome.shell.keybindings switch-to-application-1 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-2 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-3 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-4 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-5 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-6 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-7 "[]"
gsettings set org.gnome.shell.keybindings switch-to-application-8 "[]"

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "['<Super>7']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-8 "['<Super>8']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-9 "['<Super>9']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>10']"

# General settings
gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>s']" 
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Shift><Super>q']"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"

# Custom keybind 0
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super>d"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "rofi -show combi -theme Arc"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "rofi"

dconf write /org/gnome/shell/extensions/paperwm/use-default-background true
dconf write /org/gnome/mutter/dynamic-workspaces false
dconf write /org/gnome/shell/overrides/dynamic-workspaces false
dconf write /org/gnome/desktop/wm/preferences/num-workspaces "6"

# Reset the PaperWM workspace names, so we force it to use the new ones
dconf reset -f /org/gnome/shell/extensions/paperwm/workspaces/
gsettings set org.gnome.desktop.wm.preferences workspace-names "['', '', '', '', '', '']"    

# Theme settings
dconf write /org/gnome/desktop/interface/gtk-theme "'Arc-Darker'"
dconf write /org/gnome/desktop/interface/icon-theme "'elementary'"
dconf write /org/gnome/desktop/interface/cursor-theme "'elementary'"
# dconf write /org/gnome/terminal/legacy/theme-variant "'dark'"

dconf write /org/gnome/desktop/peripherals/mouse/natural-scroll "'true'"
