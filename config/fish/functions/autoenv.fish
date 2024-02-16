# search for a .env.fish file UP THE DIRECTORY TREE, starting from the current folder.
# if found, execute it.
# Intended for automatically switching to the python  virtual environment on entering the
# directories.  Can put in other initialization stuff.

function cd --description 'change directory - fish overload'

    builtin cd $param $argv

    set -l check_dir (pwd)
    # if .env.fish is found in the home directory:
    if test -f "$check_dir/.env.fish"
        source $check_dir/.env.fish
        echo "executed: source $check_dir/.env.fish"
        return
    end

    # Look up the directory tree for .env.fish:
    set check_dir (string split -r -m 1 / $check_dir)[1]

    while test $check_dir
        if test -f "$check_dir/.env.fish"
            source $check_dir/.env.fish
            echo "executed: source $check_dir/.env.fish"
            break;
        else
            set check_dir (string split -r -m 1 / $check_dir)[1]
        end  # if ... else ...
    end  # while 
end  # function
