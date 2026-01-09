#!/bin/bash

# --- MY-DOT-LEGACY INSTALLER ---
# "Because life is too short for default settings."

# Colors
GREEN="\e[32m"
BLUE="\e[34m"
RED="\e[31m"
RESET="\e[0m"

echo -e "${BLUE}🚀 Igniting the 'my-dot-legacy' boosters... Hold onto your keyboard!${RESET}"

# 1. CHECK: CachyOS / Arch Environment
if ! command -v yay &>/dev/null; then
  echo -e "${RED}💥 Error: 'yay' is missing! Are you even running Arch/CachyOS? Go get it, I'll wait.${RESET}"
  exit 1
fi

# 2. SOFTWARE INSTALLATION
echo -e "${BLUE}📦 Summoning the digital spirits (installing packages)...${RESET}"

# Official Packages
PKGS=(
  git
  zsh
  neovim
  fastfetch
  cava
  btop
  eza
  zoxide
  fzf
  bat
  ripgrep
  imagemagick
  ttf-jetbrains-mono-nerd
)

# AUR / CachyOS Packages (Ghostty, etc.)
PKGS_AUR=(
  ghostty
  yazi
  cbonsai-git
  localsend-bin
  starship
)

# System Update & Installation
# "Noconfirm" because we trust the process (and like to live dangerously)
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm "${PKGS[@]}"
yay -S --needed --noconfirm "${PKGS_AUR[@]}"

echo -e "${GREEN}✅ Arsenal acquired. Your system is now armed and dangerous.${RESET}"

# 3. COPY CONFIGS (WITH BACKUP)
echo -e "${BLUE}📂 Teleporting dotfiles to their new home...${RESET}"

SOURCE_DIR=$(pwd)
TARGET_DIR="$HOME/.config"
BACKUP_DATE=$(date +%Y%m%d_%H%M%S)

# Function: Backup and Copy
deploy_config() {
  FOLDER=$1
  if [ -d "$SOURCE_DIR/.config/$FOLDER" ]; then
    echo " -> Tuning $FOLDER..."
    # Create backup if folder exists
    if [ -d "$TARGET_DIR/$FOLDER" ]; then
      mv "$TARGET_DIR/$FOLDER" "$TARGET_DIR/${FOLDER}_backup_$BACKUP_DATE"
      echo "    (Saved your old stuff to: ${FOLDER}_backup_$BACKUP_DATE)"
    fi
    # Copy
    cp -r "$SOURCE_DIR/.config/$FOLDER" "$TARGET_DIR/"
  fi
}

# List of folders to deploy
FOLDERS=("hypr" "ghostty" "fastfetch" "nvim" "cava" "quickshell" "illogical-impulse" "zellij")

for f in "${FOLDERS[@]}"; do
  deploy_config "$f"
done

# 4. SINGLE FILES (.zshrc & starship)

# .zshrc
if [ -f "$SOURCE_DIR/.zshrc" ]; then
  echo " -> Injecting the ultimate .zshrc"
  [ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc_backup_$BACKUP_DATE"
  cp "$SOURCE_DIR/.zshrc" "$HOME/.zshrc"
fi

# starship.toml
if [ -f "$SOURCE_DIR/.config/starship.toml" ]; then
  echo " -> Launching Starship config"
  [ -f "$TARGET_DIR/starship.toml" ] && mv "$TARGET_DIR/starship.toml" "$TARGET_DIR/starship.toml_backup_$BACKUP_DATE"
  cp "$SOURCE_DIR/.config/starship.toml" "$TARGET_DIR/starship.toml"
fi

# 5. FINALIZATION
echo -e "${BLUE}🧹 Granting superpowers to scripts (chmod +x)...${RESET}"
chmod +x "$TARGET_DIR/hypr/scripts/"* 2>/dev/null

echo -e "${GREEN}🎉 MISSION ACCOMPLISHED! Welcome to the cool kids' club.${RESET}"
echo -e "👉 Please reboot or logout now to let the magic happen."
