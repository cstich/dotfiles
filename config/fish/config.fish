function fish_prompt
    eval powerline-go -modules 'nix-shell,venv,host,cwd,ssh,perms,root,git,exit'  -error $status -jobs (count (jobs -p)) -cwd-mode semi-fancy -cwd-mode semi-fancy -hostname-only-if-ssh -newline
end

# Disable vi mode indicator because powerline-go does not properly render it
function fish_mode_prompt
end

# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
set fish_cursor_default block
# Set the insert mode cursor to a line
set fish_cursor_insert line
# Set the replace mode cursor to an underscore
set fish_cursor_replace_one underscore

# Define replace ls with exa
alias ls="exa --icons"
alias ll="exa -la --icons"

# Setup direnv (should be last)
direnv hook fish | source
