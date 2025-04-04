#!/bin/bash
set -e

# Definiere die Pfade
SERVER_PATH="/opt/minecraft/server"
WORLD_PATH="$SERVER_PATH/world"

CONFIGS_PATH="$SERVER_PATH/config"         # Zielordner für Configs
MODS_PATH="$SERVER_PATH/mods"                # Zielordner für Mods

REPO_PATH="/opt/minecraft/datapacks_repo"    # Lokaler Klon des Repositories
GIT_REPO="https://github.com/Loony2392/mc-gemuesefach.git"

# Erstelle alle Zielverzeichnisse, falls sie noch nicht existieren
mkdir -p "$CONFIGS_PATH" "$MODS_PATH"

# Falls das Repository noch nicht geklont wurde, klone es
if [ ! -d "$REPO_PATH/.git" ]; then
  git clone --depth=1 "$GIT_REPO" "$REPO_PATH"
else
  cd "$REPO_PATH"
  git pull origin main
fi

### 1. Configs abgleichen (nur Dateien überschreiben, keine löschen)
rsync -av --ignore-existing "$REPO_PATH/config/" "$CONFIGS_PATH/"

### 2. Mods abgleichen (nur .jar-Dateien ersetzen, andere Dateien/Ordner unverändert)
# Kopiere nur .jar-Dateien aus dem Repo in den Mods-Ordner
find "$REPO_PATH/mods/" -name "*.jar" -exec cp -u {} "$MODS_PATH/" \;

# Setze die richtigen Rechte (anpassen, falls erforderlich)
chown -R 1000:1000 "$CONFIGS_PATH" "$DATAPACKS_PATH" "$MODS_PATH"
