# Use this shell script to set all the options for dconf
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false

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

dconf write /org/gnome/shell/extensions/paperwm/use-default-background true
dconf write /org/gnome/mutter/dynamic-workspaces false
dconf write /org/gnome/shell/overrides/dynamic-workspaces false
dconf write /org/gnome/desktop/wm/preferences/num-workspaces "6"
dconf write /org/gnome/shell/extensions/paperwm/workspaces "['c3b27fa0-6955-4f15-bcbd-1e435b70a14b', '752bc2d2-444a-41d8-b036-c268e788bfb8', 'a368f77d-dce0-46b5-b901-cd94318d9a2e', '75c7e663-77af-4ec4-b18a-e4f3361108e3', '5e8211fb-1bde-4d88-aaf2-283a8e14f2ab', '088150ba-dd12-48f0-9b5b-a4edd27271ad']"
dconf write /org/gnome/shell/extensions/paperwm/workspaces/c3b27fa0-6955-4f15-bcbd-1e435b70a14b/name "''"
dconf write /org/gnome/shell/extensions/paperwm/workspaces/752bc2d2-444a-41d8-b036-c268e788bfb8/name "''"
dconf write /org/gnome/shell/extensions/paperwm/workspaces/a368f77d-dce0-46b5-b901-cd94318d9a2e/name "''"
dconf write /org/gnome/shell/extensions/paperwm/workspaces/75c7e663-77af-4ec4-b18a-e4f3361108e3/name "''"
dconf write /org/gnome/shell/extensions/paperwm/workspaces/5e8211fb-1bde-4d88-aaf2-283a8e14f2ab/name "''"
dconf write /org/gnome/shell/extensions/paperwm/workspaces/088150ba-dd12-48f0-9b5b-a4edd27271ad/name "''"

# Theme settings
dconf write /org/gnome/desktop/interface/gtk-theme "'Arc-Darker'"
dconf write /org/gnome/desktop/interface/icon-theme "'elementary'"
dconf write /org/gnome/desktop/interface/cursor-theme "'elementary'"
# dconf write /org/gnome/terminal/legacy/theme-variant "'dark'"

dconf write /org/gnome/desktop/peripherals/mouse/natural-scroll "'true'"
