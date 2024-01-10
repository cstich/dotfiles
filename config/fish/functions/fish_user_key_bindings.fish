function fish_user_key_bindings
  bind \e\[1\;5C forward-word
  bind \e\[1\;5D backward-word
  bind \cg 'git diff; commandline -f repaint'
end
