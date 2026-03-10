#!/bin/bash
# Event hook handler for disks_mounted event
# No wait loops needed — disks_mounted guarantees the array is ready

LOGFILE="/var/log/claude-code-install.log"
INSTALL_SCRIPT="/usr/local/emhttp/plugins/claude-code/scripts/install-claude.sh"

echo "=== Claude Code disks_mounted event $(date) ===" >> "$LOGFILE"

# Run install in background to avoid blocking event processing
(
    export PATH="/root/.local/bin:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin"
    export HOME="/root"
    "$INSTALL_SCRIPT" >> "$LOGFILE" 2>&1
) &
