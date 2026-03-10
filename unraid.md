This plugin installs the [Claude Code](https://github.com/anthropics/claude-code) CLI on your Unraid server. Claude Code is Anthropic's official AI-powered coding assistant that runs directly in your terminal.

**Install**

```
plugin install https://raw.githubusercontent.com/brianpugh/unraid-claude-code/main/claude-code.plg
```

Or search for "Claude Code" in Community Applications.

**Features**

- Installs Claude Code CLI via the official Anthropic installer
- Authentication and settings persist across reboots (stored in your appdata)
- Configurable appdata path via Settings > Utilities > Claude Code
- Cached binary restores instantly on reboot without needing internet
- Auto-detects your appdata location from Docker config

**Requirements**

- Unraid 6.12.0+
- Array started (or appdata on an Unassigned Devices mount)
- Internet connection for first install

**Usage**

Open the Unraid terminal and run:

```
claude
```

Follow the authentication prompts on first launch. After that, your credentials are saved to your appdata folder and persist across reboots.

**Settings**

Navigate to Settings > Utilities > Claude Code to:
- View install status and version
- Change the appdata storage path
- Reinstall Claude Code

**Troubleshooting**

Check the install log:

```
cat /var/log/claude-code-install.log
```

Re-run the installer manually:

```
/usr/local/emhttp/plugins/claude-code/scripts/install-claude.sh
```

**Links**

- GitHub: https://github.com/brianpugh/unraid-claude-code
- Issues: https://github.com/brianpugh/unraid-claude-code/issues
