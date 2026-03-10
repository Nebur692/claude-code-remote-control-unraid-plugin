#!/bin/bash

# Don't use set -e - we want to continue even if some steps fail

PLUGIN_CFG="/boot/config/plugins/claude-code/claude-code.cfg"
CLAUDE_CONFIG_RUNTIME="/root/.claude"

# Load config
if [ -f "$PLUGIN_CFG" ]; then
    source "$PLUGIN_CFG"
fi

# Auto-detect appdata path if not set
AUTO_DETECTED=false
if [ -z "$APPDATA_PATH" ]; then
    AUTO_DETECTED=true
    echo "Auto-detecting appdata path..."

    # Method 1: Check Docker default storage path
    if [ -f "/boot/config/docker.cfg" ]; then
        DOCKER_APPDATA=$(grep -E '^DOCKER_APP_CONFIG_PATH=' /boot/config/docker.cfg 2>/dev/null | cut -d'"' -f2)
        if [ -n "$DOCKER_APPDATA" ] && [ -d "$(dirname "$DOCKER_APPDATA")" ]; then
            APPDATA_PATH="${DOCKER_APPDATA%/}/claude-code"
            echo "Detected from Docker config: $APPDATA_PATH"
        fi
    fi

    # Method 2: Look for existing appdata directories
    if [ -z "$APPDATA_PATH" ]; then
        for candidate in /mnt/user/appdata /mnt/disks/*/appdata /mnt/cache/appdata; do
            if [ -d "$candidate" ]; then
                APPDATA_PATH="$candidate/claude-code"
                echo "Found appdata directory: $APPDATA_PATH"
                break
            fi
        done
    fi

    # Fallback
    if [ -z "$APPDATA_PATH" ]; then
        APPDATA_PATH="/mnt/user/appdata/claude-code"
        echo "Using default: $APPDATA_PATH"
    fi
fi

CACHED_BINARY="$APPDATA_PATH/bin/claude"

echo "=== Claude Code Installation ==="

ensure_symlink() {
    # Always ensure /usr/local/bin/claude symlink exists so claude is on
    # PATH for interactive shells (which don't have ~/.local/bin in PATH)
    if [ -x /usr/local/bin/claude ]; then
        return 0
    fi
    for candidate in /root/.local/bin/claude /root/.claude/local/bin/claude; do
        if [ -x "$candidate" ]; then
            ln -sf "$candidate" /usr/local/bin/claude
            echo "Symlinked $candidate -> /usr/local/bin/claude"
            return 0
        fi
    done
    return 1
}

restore_cached_binary() {
    # Restore binary from appdata cache (avoids re-downloading on every boot)
    if [ -f "$CACHED_BINARY" ]; then
        echo "Restoring Claude Code from cache..."
        mkdir -p /root/.local/bin
        cp "$CACHED_BINARY" /root/.local/bin/claude
        chmod +x /root/.local/bin/claude
        return 0
    fi
    return 1
}

cache_binary() {
    # Cache the binary to appdata so it survives reboots
    if [ -x /root/.local/bin/claude ]; then
        mkdir -p "$APPDATA_PATH/bin"
        cp /root/.local/bin/claude "$CACHED_BINARY"
        echo "Cached Claude binary for future boots."
    fi
}

install_claude_code() {
    # Check if claude works (not just exists)
    local ver
    ver=$(claude --version 2>/dev/null)
    if [ -n "$ver" ]; then
        echo "Claude Code already installed: $ver"
        ensure_symlink
        return 0
    fi

    # Try restoring from cache first (fast, no network needed)
    if restore_cached_binary; then
        ensure_symlink
        ver=$(claude --version 2>/dev/null)
        if [ -n "$ver" ]; then
            echo "Claude Code restored from cache: $ver"
            return 0
        fi
        echo "Cached binary didn't work, falling back to installer..."
    fi

    # Full install via native installer
    echo "Installing Claude Code via native installer..."
    local installer
    installer=$(mktemp /tmp/claude-install.XXXXXX)
    if ! curl -fsSL https://claude.ai/install.sh -o "$installer"; then
        echo "Failed to download installer."
        rm -f "$installer"
        return 1
    fi
    if ! bash "$installer"; then
        echo "Installer script failed."
        rm -f "$installer"
        return 1
    fi
    rm -f "$installer"

    ensure_symlink
    cache_binary

    if command -v claude &> /dev/null; then
        echo "Claude Code installed successfully!"
    else
        echo "WARNING: Claude Code installer completed but 'claude' not found in PATH"
        return 1
    fi
}

setup_persistence() {
    echo "Setting up persistent storage..."
    echo "Appdata path: $APPDATA_PATH"

    # Early exit if symlink is already correct
    if [ -L "$CLAUDE_CONFIG_RUNTIME" ] && [ "$(readlink "$CLAUDE_CONFIG_RUNTIME")" = "$APPDATA_PATH/.claude" ]; then
        echo "Persistence already configured."
        return 0
    fi

    # Create appdata directory if it doesn't exist
    mkdir -p "$APPDATA_PATH"

    # If runtime config exists as a real directory (not symlink), migrate it
    if [ -d "$CLAUDE_CONFIG_RUNTIME" ] && [ ! -L "$CLAUDE_CONFIG_RUNTIME" ]; then
        echo "Migrating existing Claude config to appdata..."
        if [ -d "$APPDATA_PATH/.claude" ]; then
            # Merge: appdata takes precedence, but copy any missing files from runtime
            shopt -s dotglob
            cp -an "$CLAUDE_CONFIG_RUNTIME"/* "$APPDATA_PATH/.claude/" 2>/dev/null || true
            shopt -u dotglob
        else
            mv "$CLAUDE_CONFIG_RUNTIME" "$APPDATA_PATH/.claude"
        fi
        rm -rf "$CLAUDE_CONFIG_RUNTIME"
    fi

    # Create .claude directory in appdata if needed
    mkdir -p "$APPDATA_PATH/.claude"

    # Create symlink (ln -sf handles removing existing symlink)
    ln -snf "$APPDATA_PATH/.claude" "$CLAUDE_CONFIG_RUNTIME"

    # Save auto-detected path to config so it's consistent on future boots
    if [ "$AUTO_DETECTED" = true ]; then
        echo "APPDATA_PATH=\"$APPDATA_PATH\"" > "$PLUGIN_CFG"
        echo "Saved appdata path to config."
    fi

    echo "Persistence configured: $CLAUDE_CONFIG_RUNTIME -> $APPDATA_PATH/.claude"
}

setup_claude_json() {
    # /root/.claude.json is a separate config file on tmpfs, lost on reboot.
    # Persist it by symlinking to appdata.
    local src="/root/.claude.json"
    local dest="$APPDATA_PATH/.claude.json"

    # If real file exists (not symlink), move it to appdata
    if [ -f "$src" ] && [ ! -L "$src" ]; then
        mv "$src" "$dest"
    fi

    # Ensure the symlink exists
    if [ ! -L "$src" ]; then
        touch "$dest"
        ln -snf "$dest" "$src"
        echo "Linked .claude.json to appdata."
    fi
}

# Main

# Set up persistence first so the native installer writes into appdata
# (the installer writes to ~/.claude/local/ which follows our symlink)
setup_persistence
setup_claude_json

if ! install_claude_code; then
    echo "WARNING: Failed to install Claude Code"
    echo "You can retry manually: /usr/local/emhttp/plugins/claude-code/scripts/install-claude.sh"
    echo "Or install manually: curl -fsSL https://claude.ai/install.sh | bash"
fi

echo ""
if command -v claude &> /dev/null; then
    echo "=== Installation Complete ==="
    echo "Run 'claude' to start using Claude Code."
    echo "Your authentication will persist in: $APPDATA_PATH"
else
    echo "=== Installation Incomplete ==="
    echo "Claude Code is not yet available."
    echo "Check /var/log/claude-code-install.log for details."
    echo ""
    echo "Troubleshooting:"
    echo "  1. Make sure you have network connectivity"
    echo "  2. Try running: /usr/local/emhttp/plugins/claude-code/scripts/install-claude.sh"
fi
