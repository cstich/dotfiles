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

# ssh agent
function sshagent_findsockets
	find /tmp -uid (id -u) -type s -name agent.\* 2>/dev/null
end

function sshagent_testsocket
    if [ ! -x (command which ssh-add) ] ;
        echo "ssh-add is not available; agent testing aborted"
        return 1
    end

    if [ X"$argv[1]" != X ] ;
    	set -xg SSH_AUTH_SOCK $argv[1]
    end

    if [ X"$SSH_AUTH_SOCK" = X ]
    	return 2
    end

    if [ -S $SSH_AUTH_SOCK ] ;
        ssh-add -l > /dev/null
        if [ $status = 2 ] ;
            echo "Socket $SSH_AUTH_SOCK is dead!  Deleting!"
            rm -f $SSH_AUTH_SOCK
            return 4
        else ;
            echo "Found ssh-agent $SSH_AUTH_SOCK"
            return 0
        end
    else ;
        echo "$SSH_AUTH_SOCK is not a socket!"
        return 3
    end
end


function ssh_agent_init
    # ssh agent sockets can be attached to a ssh daemon process or an
    # ssh-agent process.

    set -l AGENTFOUND 0

    # Attempt to find and use the ssh-agent in the current environment
    if sshagent_testsocket ;
        set AGENTFOUND 1
    end

    # If there is no agent in the environment, search /tmp for
    # possible agents to reuse before starting a fresh ssh-agent
    # process.
    if [ $AGENTFOUND = 0 ];
        for agentsocket in (sshagent_findsockets)
            if [ $AGENTFOUND != 0 ] ;
	            break
            end
            if sshagent_testsocket $agentsocket ;
	       set AGENTFOUND 1
	    end

        end
    end

    # If at this point we still haven't located an agent, it's time to
    # start a new one
    if [ $AGENTFOUND = 0 ] ;
        echo need to start a new agent
        eval (ssh-agent -c)
    end

    # Finally, show what keys are currently in the agent
    # ssh-add -l
end

ssh_agent_init
