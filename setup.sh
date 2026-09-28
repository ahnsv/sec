#!/usr/bin/env bash
set -euo pipefail

brew bundle --file="$(dirname "$0")/Brewfile"

mkdir -p ~/Library/Logs
cp "$(dirname "$0")/com.local.clamscan.plist" ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.local.clamscan.plist

echo "Open LuLu.app and BlockBlock.app once each to grant them a full disk / notification permissions and enable at login."
