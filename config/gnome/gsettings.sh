# Use this shell script to set all the options for dconf
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false

# Have nautilus/file dialogs display folders first
gsettings set org.gtk.Settings.FileChooser sort-directories-first true

# PaperWM settings
dconf write /org/gnome/shell/extensions/paperwm/keybindings/close-window "['<Super>q']"
dconf write /org/gnome/shell/extensions/paperwm/keybindings/move-left "['<Shift><Super>h', '<Super><Shift>comma', '<Super><Ctrl>Left']"
dconf write /org/gnome/shell/extensions/paperwm/keybindings/move-right "['<Shift><Super>l', '<Super><Shift>period', '<Super><Ctrl>Right']"
dconf write /org/gnome/shell/extensions/paperwm/keybindings/switch-down "['<Super>j']"
dconf write /org/gnome/shell/extensions/paperwm/keybindings/switch-left "['<Super>h']"
dconf write /org/gnome/shell/extensions/paperwm/keybindings/switch-next "['<Super>period']"
dconf write /org/gnome/shell/extensions/paperwm/keybindings/switch-previous "['<Super>comma']"
dconf write /org/gnome/shell/extensions/paperwm/keybindings/switch-right "['<Super>l']"
dconf write /org/gnome/shell/extensions/paperwm/keybindings/switch-up "['<Super>k']"

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
