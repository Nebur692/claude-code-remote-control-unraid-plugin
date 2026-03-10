#!/bin/bash
# Post-install script for claude-code Slackware package
# Creates event hook symlink so Unraid fires our script on disks_mounted

cd usr/local/emhttp/plugins/claude-code/event 2>/dev/null || true
ln -sf ../scripts/on-disks-mounted.sh disks_mounted

# Fix logrotate permissions
chmod 0644 /etc/logrotate.d/claude-code 2>/dev/null || true
