#!/bin/bash
set -e

# Definiere die Pfade
SERVER_PATH="/opt/minecraft/server"
MODS_PATH="$SERVER_PATH/mods"    # Pfad für den Mods-Ordner
REPO_PATH="/opt/minecraft/datapacks_repo"
GIT_REPO="https://github.com/Loony2392/mc-gemuesefach.git"

# Stelle sicher, dass das Zielverzeichnis existiert
mkdir -p "$MODS_PATH"

# Falls das Repository nicht existiert, klone es
if [ ! -d "$REPO_PATH/.git" ]; then
  git clone --depth=1 "$GIT_REPO" "$REPO_PATH"
else
  # Falls es bereits existiert, hole die neuesten Änderungen
  cd "$REPO_PATH"
  git pull origin main
fi

# Entferne alle nicht .jar Dateien im Mods-Ordner
find "$MODS_PATH" ! -name "*.jar" -type f -exec rm -f {} \;

# Kopiere nur .jar-Dateien aus dem Repo in den Mods-Ordner
find "$REPO_PATH/mods/" -name "*.jar" -exec cp -u {} "$MODS_PATH/" \;

# Setze die richtigen Rechte
chown -R 1000:1000 "$MODS_PATH"