#!/usr/bin/env bash

apt install flatpak flatpak-builder gsettings-desktop-schemas appstream \
  libglib2.0-dev libjson-glib-dev libcurl4-openssl-dev libelf-dev libxml2-dev libostree-dev
export XDG_DATA_DIRS=$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:/root/.local/share/flatpak/exports/share
export GSETTINGS_SCHEMA_DIR=/usr/share/glib-2.0/schemas
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --user flathub org.freedesktop.Sdk//24.08 -y
flatpak-builder --force-clean --install --user -y builddir org.redotengine.Redot.yaml
