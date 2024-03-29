local wezterm = require 'wezterm';

return {
  default_prog = {"zsh"},
  font = wezterm.font("Fira Code Nerd Font"),
  color_scheme = "OneHalfLight",
  warn_about_missing_glyphs= false,
  exit_behavior = "Close",
  hide_tab_bar_if_only_one_tab = true,
  term = "wezterm",
  check_for_updates = false,
  show_update_window = false,
  window_decorations = "NONE",

  colors = {
    ansi = {
    '#383a42',
    '#e45649',
    '#50a14f',
    '#c18401',
    '#0184bc',
    '#a626a4',
    '#0997b3',
    '#fafafa',
    },
    background = '#fafafa',
    brights = {
        '#4f525e',
        '#e06c75',
        '#98c379',
        '#e5c07b',
        '#61afef',
        '#c678dd',
        '#56b6c2',
        '#ffffff',
    },
    cursor_bg = '#bfceff',
    cursor_border = '#bfceff',
    cursor_fg = '#383a42',
    foreground = '#383a42',
    selection_bg = '#bfceff',
    selection_fg = '#383a42',
    },
}
