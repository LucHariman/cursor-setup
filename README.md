# Cursor Setup Script

A bash script to automatically download and install the latest version of Cursor (AI-powered code editor) on Debian-based Linux systems.

## Background

Cursor is an AI-powered code editor that's distributed as an AppImage for Linux users. However, many Linux users face challenges when trying to run Cursor directly from the AppImage:

- **Sandbox permission issues**: The Chrome sandbox component requires specific file permissions and ownership to function properly
- **Desktop integration problems**: AppImages don't automatically integrate with desktop environments (no menu entries, icons, or CLI commands)
- **Manual setup complexity**: Users often need to manually extract AppImages, set permissions, and create desktop shortcuts
- **Inconsistent behavior**: Running AppImages directly can lead to permission errors, sandbox failures, and poor system integration

This script addresses these issues by properly extracting the AppImage, setting the correct permissions for the Chrome sandbox, and integrating Cursor seamlessly into the Linux system.

## What it does

This script:
- Fetches the latest Cursor version information from the official repository
- Downloads the Linux x64 AppImage
- Extracts and installs Cursor to `/usr/local/share/cursor`
- Sets up proper file permissions for the Chrome sandbox
- Creates a CLI command (`cursor`) in `/usr/local/bin`
- Installs desktop integration (application menu and icon)

## Installation

0. Install `jq` (for parsing JSON data) if not installed yet
```bash
sudo apt install jq
```

1. Download the script:
```bash
wget https://raw.githubusercontent.com/LucHariman/cursor-setup/main/cursor-setup.sh
```

2. Make it executable:
```bash
chmod +x cursor-setup.sh
```

3. Run the script:
```bash
./cursor-setup.sh
```

## Usage

After installation, you can:

- Launch Cursor from the application menu
- Run `cursor` from the terminal
- Find the executable at `/usr/local/bin/cursor`

### Updating Cursor

To update Cursor to the latest version, simply rerun the script. It will automatically download and install the newest version, replacing the existing installation.

## What gets installed

- **Application**: `/usr/local/share/cursor/`
- **CLI command**: `/usr/local/bin/cursor`
- **Desktop file**: `/usr/share/applications/cursor.desktop`
- **Icon**: `/usr/share/icons/co.anysphere.cursor.png`

## Uninstallation

To remove Cursor:
```bash
sudo rm -rf /usr/local/share/cursor
sudo rm -f /usr/local/bin/cursor
sudo rm -f /usr/share/applications/cursor.desktop
sudo rm -f /usr/share/icons/co.anysphere.cursor.png
```

## License

This script is licensed under the MIT License. See the license header in the script for details.

## Contributing

Feel free to submit issues, feature requests, or pull requests to improve this script.

## Disclaimer

This is an unofficial installation script. Cursor is developed by Anysphere Inc. This script is not affiliated with or endorsed by Anysphere.
