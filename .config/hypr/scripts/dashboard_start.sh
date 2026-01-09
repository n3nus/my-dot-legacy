#!/bin/bash

# Funktion: Startet App und wartet, bis Hyprland sie sieht
start_and_wait() {
  TITLE=$1
  CMD=$2

  # Starten
  ghostty --title="$TITLE" -e "$CMD" &

  # Warten (Maximal 5 Sekunden), bis das Fenster in der Hyprland-Liste auftaucht
  for i in {1..50}; do
    if hyprctl clients | grep -q "title: $TITLE"; then
      return 0
    fi
    sleep 0.1
  done
}

# 1. Sicherstellen, dass wir auf Workspace 1 sind
hyprctl dispatch workspace 1

# 2. HAUPTFENSTER (Rechts) - Fastfetch
# Wir starten es zuerst. Es nimmt den ganzen Platz ein.
start_and_wait "dash_main" "zsh -i -c 'fastfetch; exec zsh'"

# 3. VISUALIZER (Links) - Cava
# Wenn das zweite Fenster kommt, teilt Hyprland automatisch 50/50.
# Wir setzen Cava nach LINKS.
start_and_wait "dash_cava" "cava"
hyprctl dispatch movewindow l

# 4. ZEN MODE (Links Unten) - Bonsai
# Wir fokussieren Cava (links) und splitten es.
hyprctl dispatch focuswindow title:dash_cava
hyprctl dispatch togglesplit # Stellt sicher, dass der Split vertikal (oben/unten) passiert
start_and_wait "dash_bonsai" "cbonsai -l -i"

# 5. Fokus zurück auf Main
hyprctl dispatch focuswindow title:dash_main
