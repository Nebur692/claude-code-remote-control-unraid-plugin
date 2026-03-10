#!/bin/bash
# Update Claude Code by clearing the cached binary and re-installing

PLUGIN_CFG="/boot/config/plugins/claude-code/claude-code.cfg"

# Load config
if [ -f "$PLUGIN_CFG" ]; then
    source "$PLUGIN_CFG"
fi

APPDATA_PATH="${APPDATA_PATH:-/mnt/user/appdata/claude-code}"

echo "Clearing cached Claude Code binary..."
rm -f "$APPDATA_PATH/bin/claude" /root/.local/bin/claude /usr/local/bin/claude

echo "Reinstalling Claude Code..."
/usr/local/emhttp/plugins/claude-code/scripts/install-claude.sh
