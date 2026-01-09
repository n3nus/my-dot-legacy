#!/bin/bash

# --- MY-DOT-LEGACY ULTIMATE INSTALLER ---
# "One script to rule them all."

# Colors
GREEN="\e[32m"
BLUE="\e[34m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

echo -e "${BLUE}🚀 Igniting the 'my-dot-legacy' boosters...${RESET}"

# --- 1. THE FOUNDATION (End4) ---
echo -e "${BLUE}🏗️  Downloading and running End4 Installer (Base System)...${RESET}"
echo -e "${YELLOW}👉 IMPORTANT: When asked 'Do you want to confirm every time?', type 'n' (No) to speed it up!${RESET}"

export UV_VENV_CLEAR=1

# end4 script
bash <(curl -s https://ii.clsty.link/get)

echo -e "${GREEN}✅ Base system installed. Now applying YOUR upgrades...${RESET}"

# --- 2. PRÜFUNG ---
if ! command -v yay &>/dev/null; then
  echo -e "${RED}💥 Error: 'yay' is missing! Are you even running Arch/CachyOS? Go get it.${RESET}"
  exit 1
fi

# --- 3. SOFTWARE INSTALLATION ---
echo -e "${BLUE}📦 Installing the cool stuff (Ghostty, LazyVim, Cava)...${RESET}"

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
  fd
  imagemagick
  ttf-jetbrains-mono-nerd
)

# AUR / CachyOS Packages
PKGS_AUR=(
  ghostty
  yazi
  cbonsai-git
  localsend-bin
  starship
)

sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm "${PKGS[@]}"
yay -S --needed --noconfirm "${PKGS_AUR[@]}"

echo -e "${GREEN}✅ Arsenal acquired.${RESET}"

# --- 4. COPY CONFIGS (Overwriting End4 defaults) ---
echo -e "${BLUE}📂 Overwriting configs with YOUR style...${RESET}"

SOURCE_DIR=$(pwd)
TARGET_DIR="$HOME/.config"
BACKUP_DATE=$(date +%Y%m%d_%H%M%S)

# Funktion: Backup und Kopieren
deploy_config() {
  FOLDER=$1
  if [ -d "$SOURCE_DIR/.config/$FOLDER" ]; then
    echo " -> Deploying $FOLDER..."
    # Backup erstellen
    if [ -d "$TARGET_DIR/$FOLDER" ]; then
      # backup of old
      mv "$TARGET_DIR/$FOLDER" "$TARGET_DIR/${FOLDER}_backup_$BACKUP_DATE"
    fi
    # Kopieren
    cp -r "$SOURCE_DIR/.config/$FOLDER" "$TARGET_DIR/"
  fi
}

FOLDERS=("hypr" "ghostty" "fastfetch" "nvim" "cava" "quickshell" "illogical-impulse" "zellij")

for f in "${FOLDERS[@]}"; do
  deploy_config "$f"
done

# --- 5. SINGLE FILES ---

# .zshrc
if [ -f "$SOURCE_DIR/.zshrc" ]; then
  echo " -> Injecting .zshrc"
  [ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc_backup_$BACKUP_DATE"
  cp "$SOURCE_DIR/.zshrc" "$HOME/.zshrc"
fi

# starship.toml
if [ -f "$SOURCE_DIR/.config/starship.toml" ]; then
  echo " -> Injecting Starship config"
  # making sure it exists
  mkdir -p "$TARGET_DIR"
  cp "$SOURCE_DIR/.config/starship.toml" "$TARGET_DIR/starship.toml"
fi

# --- 6. FINALIZATION ---
echo -e "${BLUE}🧹 Making scripts executable...${RESET}"
chmod +x "$TARGET_DIR/hypr/scripts/"* 2>/dev/null

echo -e "${GREEN}🎉 MISSION ACCOMPLISHED!${RESET}"
echo -e "👉 Please reboot now. Select 'Hyprland' at login."
