mkdir -p ~/.local/bin
cat > ~/.local/bin/kitty-sw <<'EOF'
#!/usr/bin/env bash
export LIBGL_ALWAYS_SOFTWARE=1
export GDK_BACKEND=x11   # optional but helps under flaky Wayland/VM setups
exec kitty "$@"
EOF
chmod +x ~/.local/bin/kitty-sw
