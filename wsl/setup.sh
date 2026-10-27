#!/usr/bin/env bash
set -euo pipefail

echo "🐧 Configuring WSL..."

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
BASHRC="$HOME/.bashrc"
DOTFILES_DIR="$HOME/.config/windot"

mkdir -p "$DOTFILES_DIR"

# Copy alias definitions
cp "$SCRIPT_DIR/aliases.sh" "$DOTFILES_DIR/aliases.sh"

# Copy optional functions
if [[ -f "$SCRIPT_DIR/functions.sh" ]]; then
    cp "$SCRIPT_DIR/functions.sh" "$DOTFILES_DIR/functions.sh"
fi

# Add source commands to .bashrc only once
SOURCE_LINE='[ -f "$HOME/.config/windot/aliases.sh" ] && source "$HOME/.config/windot/aliases.sh"'

if ! grep -Fqx "$SOURCE_LINE" "$BASHRC"; then
    printf '\n# Windot configuration\n%s\n' "$SOURCE_LINE" >> "$BASHRC"
fi

FUNCTION_LINE='[ -f "$HOME/.config/windot/functions.sh" ] && source "$HOME/.config/windot/functions.sh"'

if ! grep -Fqx "$FUNCTION_LINE" "$BASHRC"; then
    printf '%s\n' "$FUNCTION_LINE" >> "$BASHRC"
fi

echo "✅ WSL aliases and functions configured."