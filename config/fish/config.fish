function fish_prompt
  eval powerline-go -modules 'nix-shell,venv,host,cwd,ssh,perms,root,git,exit'  -error $status -jobs (count (jobs -p)) -cwd-mode semi-fancy -cwd-mode semi-fancy -hostname-only-if-ssh -newline
end

# Add a few custom fzf functions
function fuzzy_view_file
  set out (fd . | rg -v .venv | fzf)
  if [ -n "$out" ]
    $EDITOR $out
  end
end

# Overwrite default fzf key bindings for fish because we are using fzf.fish
bind --mode default \cr '_fzf_search_history'
bind --mode insert \cr '_fzf_search_history'
bind --mode visual \cr '_fzf_search_history'

bind --mode default \ct '_fzf_search_directory'
bind --mode insert \ct '_fzf_search_directory'
bind --mode visual \ct '_fzf_search_directory'

# Disable venv prompt because powerline-go has some issues with it
set VIRTUAL_ENV_DISABLE_PROMPT 1

# Disable vi mode indicator because powerline-go does not properly render it
function fish_mode_prompt
end

# Instead render the mode prompt on the right
function fish_right_prompt
  switch $fish_bind_mode
    case default
      set_color --bold blue
      echo 'NORMAL '
    case insert
      set_color --bold green
      echo 'INSERT '
    case replace_one
      set_color --bold red
      echo 'REPLACE '
    case visual
      set_color --bold brmagenta
      echo 'VISUAL '
    case '*'
      set_color --bold orange
      echo '? '
  end
  set_color normal
end

# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
set fish_cursor_default block
# Set the insert mode cursor to a line
set fish_cursor_insert line
# Set the replace mode cursor to an underscore
set fish_cursor_replace_one underscore

# Only run this in interactive shells
if status is-interactive
  # I'm trying to grow a neckbeard
  # fish_vi_key_bindings
  # Set the cursor shapes for the different vi modes.
  set fish_cursor_default     block      blink
  set fish_cursor_insert      line       blink
  set fish_cursor_replace_one underscore blink
  set fish_cursor_visual      block

  function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert
  end
end

# Define replace ls with exa
# TODO Update this to eza
alias ls="exa --icons"
alias ll="exa -la --icons"

# Turn off the greeting
set -g fish_greeting

# Aliases for all tools to use ssh-ident
# alias ssh="ssh-ident"
# 
# function git
#     set -x GIT_SSH "ssh-ident"
#     command git $argv
# end

# pyenv init
if command -v pyenv 1>/dev/null 2>&1
  set -Ux PYENV_ROOT $HOME/.pyenv
  set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths
  pyenv init - | source
end

# Setup direnv (should be last)
direnv hook fish | source
