local wezterm = require 'wezterm';

return {
  default_prog = {"zsh"},
  font = wezterm.font("Fira Code Nerd Font"),
  color_scheme = "OneHalfLight",
  warn_about_missing_glyphs= false,
  exit_behavior = "Close",
  hide_tab_bar_if_only_one_tab = true,
}
