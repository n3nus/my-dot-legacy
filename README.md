# 🌌 my-dot-legacy

> **"Because default settings are for people who have better things to do. We don't."**

Published for Friends :)

Welcome to my personal configuration for **CachyOS (Arch Linux) + Hyprland**.
This is a heavily modified version of the [End4 dotfiles](https://github.com/end-4/dots-hyprland), tuned for maximum performance, modern aesthetics, and a mouse-free workflow.

![Screenshot](screenshots/preview.png)


## ✨ The Goods (Tech Stack)

This setup is built for speed and looks. If it’s not fast or pretty, it’s not in here.

| Category | Tool | Why? |
| :--- | :--- | :--- |
| **OS** | CachyOS | Arch, but faster. |
| **Window Manager** | Hyprland | The smoothest Wayland compositor. |
| **Terminal** | **Ghostty** 👻 | GPU-accelerated, written in Zig, blazing fast. |
| **Editor** | **LazyVim** 💤 | Neovim made easy (and gorgeous). |
| **Shell** | Zsh + Starship | Adaptive prompt that matches your wallpaper. |
| **File Manager** | Yazi | Terminal file manager. VIM keybinds ftw. |
| **Fetch** | Fastfetch | Because `neofetch` is dead. Long live Fastfetch. |
| **Visualizer** | Cava | Makes your music look cool. |
| **Sharing** | LocalSend | AirDrop for people who value freedom. |

## 🚀 Lift Off (Installation)

I wrote a magic script that does everything for you. It installs packages, backs up your old messy configs, and symlinks the new hotness.

### Prerequisites
- A working Arch-based system (preferably **CachyOS**).
- `git` installed.
- An internet connection.

### How to install

1. **Clone the repo:**
   ```bash
   git clone https://github.com/n3nus/my-dot-legacy.git
   cd my-dot-legacy
   ```

2. **Run the magic script:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **Reboot:**
   Log out, select **Hyprland** (not UWSM) at the login screen, and enjoy.

> **⚠️ Note:** The installer will backup your existing configs to folders named like `.config/hypr_backup_2026...`. So it's safe-ish, but having your own backup never hurts.

## ⌨️ Cheat Sheet (Keybinds)

The most important shortcuts to survive:

| Keybind | Action |
| :--- | :--- |
| `Super` + `Enter` | Open **Ghostty** (Terminal) |
| `Super`        | Open App Launcher |
| `Super` + `W` | Open Browser (Zen) |
| `Super` + `E` | Open File Manager |
| `Super` + `Q` | Close Window |
| `Super` + `V` | Toggle Floating/Tiling |
| `Super` + `/` | Show Help / Cheatsheet |

## 🎨 Customization

- **Wallpaper:** Press `Super + T` to open the theme selector.
- **Terminal:** Config is located at `~/.config/ghostty/config`.
- **Hyprland:** Check `~/.config/hypr/custom/` for easy edits.

## ❤️ Credits

- Base system: [End4 Dotfiles](https://github.com/end-4/dots-hyprland) (The legend).
- Icons & Theme: Catppuccin / Material You.
- Me: For breaking things until they worked again.


