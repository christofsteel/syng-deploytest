#!/usr/bin/env bash

RELEASE_VERSION=$1
FLATPAK_VERSION=$(grep "<release version=" resources/flatpak/rocks.syng.Syng.metainfo.xml | sed 's/^[^"]*"\([^"]*\)".*$/\1/' | sort -V | tail -n 1)

[ "$RELEASE_VERSION" = "$FLATPAK_VERSION" ]
