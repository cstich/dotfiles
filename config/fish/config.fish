function fish_prompt
    # Cache container ID (optional)
    if not set -q CONTAINER_ID
        if test -f /.dockerenv
            set -gx CONTAINER_ID (cat /etc/hostname)
        else
            set -gx CONTAINER_ID ""
        end
    end

    # Build module list
    set modules nix-shell venv host cwd ssh perms root git exit
    if string length --quiet $CONTAINER_ID
        set modules shell-var $modules
    end

    # Use the appropriate prompt depending on whether you are inside Docker or not
    if contains shell-var $modules
        powerline-go \
            -modules (string join , $modules) \
            -error $status \
            -jobs (count (jobs -p)) \
            -cwd-mode semi-fancy \
            -newline \
            -hostname-only-if-ssh \
            -venv-name-size-limit 12 \
            -shell-var CONTAINER_ID $CONTAINER_ID
    else
        powerline-go \
            -modules (string join , $modules) \
            -error $status \
            -jobs (count (jobs -p)) \
            -cwd-mode semi-fancy \
            -newline \
            -hostname-only-if-ssh \
            -venv-name-size-limit 12
    end
end

# Add a few custom fzf functions
function fuzzy_view_file
    set out (fd . | rg -v .venv | fzf)
    if [ -n "$out" ]
        $EDITOR $out
    end
end

# Overwrite default fzf key bindings for fish because we are using fzf.fish
bind --mode default \cr _fzf_search_history
bind --mode insert \cr _fzf_search_history
bind --mode visual \cr _fzf_search_history

bind --mode default \ct _fzf_search_directory
bind --mode insert \ct _fzf_search_directory
bind --mode visual \ct _fzf_search_directory

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

# Go to git root
function gcd
    set -lx TOPLEVEL (git rev-parse --show-toplevel)
    if test $status -eq 0
        cd $TOPLEVEL
    end
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
    set fish_cursor_default block blink
    set fish_cursor_insert line blink
    set fish_cursor_replace_one underscore blink
    set fish_cursor_visual block

    function fish_user_key_bindings
        # Execute this once per mode that emacs bindings should be used in
        fish_default_key_bindings -M insert
        fish_vi_key_bindings --no-erase insert
    end
end

# Define replace ls with exa
if command -v eza 1>/dev/null 2>&1
    alias ls="eza --icons"
    alias ll="eza -la --icons"
    alias k="kubectl"
end

# Turn off the greeting
set -g fish_greeting

# Set TERM to xterm-kitty if kitty exists, then we are probably using kitty...
if command -v kitty 1>/dev/null 2>&1
    set TERM xterm-kitty
end

# Init zoxide if it exists
if command -v zoxide 1>/dev/null 2>&1
    zoxide init fish | source
    alias cd=z
    alias cdi=zi
end


# Init kubetcl alias if it exists
if command -v kubectl 1>/dev/null 2>&1
    alias k=kubectl
end

# Setup direnv (should be last)
# Only if it exists
if command -v direnv 1>/dev/null 2>&1
    direnv hook fish | source
end

# uv
fish_add_path --path --append "~/.local/bin"
