# Use this shell script to set all the options for dconf
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false

dconf write /org/gnome/shell/extensions/paperwm/keybindings/close-window "['<Super>q']"
dconf write /org/gnome/shell/extensions/paperwm/keybindings/move-left "['<Shift><Super>h', '<Super><Shift>comma', '<Super><Ctrl>Left']"
dconf write /org/gnome/shell/extensions/paperwm/keybindings/move-right "['<Shift><Super>l', '<Super><Shift>period', '<Super><Ctrl>Right']"
dconf write /org/gnome/shell/extensions/paperwm/keybindings/switch-down "['<Super>j']"
dconf write /org/gnome/shell/extensions/paperwm/keybindings/switch-left "['<Super>h']"
dconf write /org/gnome/shell/extensions/paperwm/keybindings/switch-next "['<Super>period']"
dconf write /org/gnome/shell/extensions/paperwm/keybindings/switch-previous "['<Super>comma']"
dconf write /org/gnome/shell/extensions/paperwm/keybindings/switch-right "['<Super>l']"
dconf write /org/gnome/shell/extensions/paperwm/keybindings/switch-up "['<Super>k']"
