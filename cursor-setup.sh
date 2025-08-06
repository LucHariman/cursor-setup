#!/bin/bash
#
# Cursor Setup Script
# 
# MIT License
# 
# Copyright (c) 2025 Luc Randrianomenjanahary
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

set -e

command -v jq >/dev/null 2>&1 || { echo "jq is required but not installed. Install with: sudo apt install jq"; exit 1; }

temp_dir=$(mktemp -d)
pushd "$temp_dir" > /dev/null
trap 'popd > /dev/null' EXIT

echo "Fetching latest version"

version_url="https://raw.githubusercontent.com/oslook/cursor-ai-downloads/main/version-history.json"
version_data=$(wget -qO- "$version_url")
if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch version information from oslook/cursor-ai-downloads"
    exit 1
fi

latest_version=$(echo "$version_data" | jq -r '.versions[0].version')
if [ "$latest_version" = "null" ] || [ -z "$latest_version" ]; then
    echo "Error: Could not find version information"
    exit 1
fi

if [[ "$(uname -m)" == "aarch64" ]] || [[ "$(uname -m)" == "arm64" ]]; then
    platform="linux-arm64"
else
    platform="linux-x64"
fi

download_url=$(echo "$version_data" | jq -r ".versions[0].platforms.\"${platform}\"")
if [ "$download_url" = "null" ] || [ -z "$download_url" ]; then
    echo "Error: Could not find ${platform} download URL in version history"
    exit 1
fi

echo "Downloading Cursor ${latest_version}"

new_app_image="./Cursor-${latest_version}-${platform}.AppImage"
wget -O "$new_app_image" "$download_url" --progress=bar
if [ $? -eq 0 ]; then
    chmod +x "$new_app_image"
else
    echo "Error: Download failed!"
    exit 1
fi


echo "Extracting new app image"

cursor_dir="/usr/local/share/cursor"
"$new_app_image" --appimage-extract > /dev/null 2>&1

if [ -d "$cursor_dir" ]; then
  sudo rm -rf "$cursor_dir"
fi
sudo mv ./squashfs-root "$cursor_dir"


echo "Setting file permissions"

sudo chown root "$cursor_dir"/usr/share/cursor/chrome-sandbox
sudo chmod 4755 "$cursor_dir"/usr/share/cursor/chrome-sandbox


echo "Setting up CLI command"
sudo ln -sf "$cursor_dir"/AppRun /usr/local/bin/cursor


echo "Setting up desktop shortcut"

sudo chmod +x "$cursor_dir"/cursor.desktop
sudo cp "$cursor_dir"/cursor.desktop /usr/share/applications/cursor.desktop
sudo cp "$cursor_dir"/co.anysphere.cursor.png /usr/share/icons/


echo "Cleaning up"

rm -rf "$temp_dir/*"


echo "Cursor ${latest_version} installed successfully."
