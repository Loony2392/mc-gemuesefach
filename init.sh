#!/bin/bash
set -e

# Definiere die Pfade
SERVER_PATH="/opt/minecraft/server"
WORLD_PATH="$SERVER_PATH/world"
CONFIGS_PATH="$SERVER_PATH/configs"
DATAPACKS_PATH="$WORLD_PATH/datapacks"
MODS_PATH="$SERVER_PATH/mods"
REPO_PATH="/opt/minecraft/datapacks_repo"
GIT_REPO="https://github.com/Loony2392/mc-gemuesefach.git"

# Stelle sicher, dass die Zielverzeichnisse existieren
mkdir -p "$CONFIGS_PATH"
mkdir -p "$DATAPACKS_PATH"
mkdir -p "$MODS_PATH"

# Falls das Repository nicht existiert, klone es
if [ ! -d "$REPO_PATH/.git" ]; then
  git clone --depth=1 "$GIT_REPO" "$REPO_PATH"
else
  # Falls es bereits existiert, hole die neuesten Änderungen
  cd "$REPO_PATH"
  git pull origin main
fi

### 1. Configs abgleichen (nur überschreiben, nicht löschen)
# Kopiere nur die Dateien (keine Verzeichnisse oder anderen Dateien)
rsync -av --ignore-existing "$REPO_PATH/configs/" "$CONFIGS_PATH/"

### 2. Datapacks abgleichen (alles ersetzen)
# Kopiere alle Datapacks und überschreibe bestehende
rsync -av --delete "$REPO_PATH/datapacks/" "$DATAPACKS_PATH/"

### 3. Mods abgleichen (nur .jar-Dateien ersetzen, keine anderen Dateien oder Ordner löschen)
# Entferne alle nicht .jar-Dateien im Mods-Ordner (falls vorhanden)
find "$MODS_PATH" ! -name "*.jar" -type f -exec rm -f {} \;

# Kopiere nur .jar-Dateien aus dem Repo in den Mods-Ordner
find "$REPO_PATH/mods/" -name "*.jar" -exec cp -u {} "$MODS_PATH/" \;

# Setze die richtigen Rechte
chown -R 1000:1000 "$CONFIGS_PATH" "$DATAPACKS_PATH" "$MODS_PATH"
