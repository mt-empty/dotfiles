#!/bin/bash
set -e

# Firefox configuration installer
# Detects your Firefox profile and applies the dotfiles user.js

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
FIREFOX_CONFIG="$DOTFILES_DIR/.mozilla/firefox/profile/user.js"

# Extension IDs for optional install prompt
EXTENSIONS=(
  "uBlock Origin:https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
  "KeePassXC-Browser:https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi"
  "Dark Reader:https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi"
)

# Detect OS and Firefox profile location
if [[ "$OSTYPE" == "darwin"* ]]; then
  FIREFOX_PROFILES="$HOME/Library/Application Support/Firefox/Profiles"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  FIREFOX_PROFILES="$HOME/.mozilla/firefox"
else
  echo "Unsupported OS: $OSTYPE"
  exit 1
fi

if [ ! -d "$FIREFOX_PROFILES" ]; then
  echo "Firefox profiles directory not found at: $FIREFOX_PROFILES"
  echo "Please install Firefox and run it at least once."
  exit 1
fi

# Find default profile
PROFILE=$(find "$FIREFOX_PROFILES" -maxdepth 1 -type d \( -name "*.default-release" -o -name "*.default" \) | head -1)

if [ -z "$PROFILE" ]; then
  echo "No Firefox profile found. Please run Firefox at least once."
  exit 1
fi

echo "Using Firefox profile: $PROFILE"

# Backup existing user.js
if [ -f "$PROFILE/user.js" ]; then
  BACKUP="$PROFILE/user.js.backup.$(date +%s)"
  cp "$PROFILE/user.js" "$BACKUP"
  echo "Backed up existing user.js to: $BACKUP"
fi

# Apply user.js
cp "$FIREFOX_CONFIG" "$PROFILE/user.js"
echo "user.js installed."

# Remind about extensions
echo ""
echo "Install these Firefox extensions manually:"
for ext in "${EXTENSIONS[@]}"; do
  name="${ext%%:*}"
  url="${ext##*:}"
  echo "  $name"
  echo "    $url"
done

echo ""
echo "Keyword bookmark suggestions (set in Firefox bookmark editor manually):"
echo "  gh     -> https://github.com/search?q=%s&type=repositories"
echo "  ghpr   -> https://github.com/pulls?q=%s"
echo "  ghi    -> https://github.com/issues?q=%s"
echo "  jira   -> https://[your-jira-domain]/issues/?jql=text+~+\"%s\""
echo "  jirat  -> https://[your-jira-domain]/browse/%s"
echo ""
echo "Done. Restart Firefox for changes to take effect."
