#!/bin/bash
# Post-install script for claude-code Slackware package

# Fix logrotate permissions
chmod 0644 /etc/logrotate.d/claude-code 2>/dev/null || true
