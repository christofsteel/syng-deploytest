#!/usr/bin/env bash

. ../utils.sh

# RUNTIME=org.kde.Platform//6.10

YT_DLP=($(curl -s https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest | jq -r '.assets[] | select (.browser_download_url | contains(".tar.gz")) | .digest, .browser_download_url'))
export YT_DLP_SHA=$(echo ${YT_DLP[0]} | cut -d : -f 2)
export YT_DLP_URL=${YT_DLP[1]}

YT_DLP_EJS=($(curl -s https://api.github.com/repos/yt-dlp/ejs/releases/latest | jq -r '.assets[] | select (.browser_download_url | contains("py3-none-any.whl")) | .digest, .browser_download_url'))
export YT_DLP_EJS_SHA=$(echo ${YT_DLP_EJS[0]} | cut -d : -f 2)
export YT_DLP_EJS_URL=${YT_DLP_EJS[1]}
export SYNG_COMMIT=$(git log -1 --format=%H)
envsubst '$YT_DLP_URL $YT_DLP_SHA $YT_DLP_EJS_URL $YT_DLP_EJS_SHA $SYNG_COMMIT' < rocks.syng.Syng.yaml.template > rocks.syng.Syng.yaml

# ./flatpak-pip-generator --yaml pdm-backend # for pymediainfo
# ./flatpak-pip-generator --yaml pybind11 # for pillow
./flatpak-pip-generator --yaml setuptools_scm[toml] # for argon2-cffi-bindings
./flatpak-pip-generator --yaml --pyproject-file ../../pyproject.toml --ignore-pkg=PySide6 --prefer-wheels=uv-build,pillow,pymediainfo --optdep-groups client --runtime org.kde.Sdk//6.10

# uv export --extra client > requirements-client_in.txt
#
# ./flatpak-pip-generator --build-only --yaml expandvars
# ./flatpak-pip-generator --build-only --yaml --prefer-wheels=uv-build --runtime io.qt.PySide.BaseApp//6.10 uv-build
# ./flatpak-pip-generator --yaml cffi
# ./flatpak-pip-generator --yaml pybind11
# ./flatpak-pip-generator --yaml setuptools_scm[toml]
#
# AWK_PROG='
#     BEGIN { inside_block = 0 }
#     # Handle continuation lines
#     /\\$/ {
#       if (inside_block == 0 && $0 ~ package) { inside_block = 1 }
#       if (inside_block == 1) { next }
#     }
#     {
#       # End of a multi-line block
#       if (inside_block == 1 && !/\\$/) { inside_block = 0; next }
#       if (inside_block == 0 && $0 ~ package) { next }
#       print
#     }'
# awk -v package="pyside6" "$AWK_PROG" "requirements-client_in.txt" \
#   | awk -v package="shiboken6" "$AWK_PROG" \
#   | awk -v package="brotlicffi" "$AWK_PROG" \
#   | awk -v package="colorama" "$AWK_PROG" \
#   | awk -v package="ruff" "$AWK_PROG" \
#   | awk -v package="mypy" "$AWK_PROG" \
#   | sed 's/-e .//g' \
#   > "requirements-client.txt"
#
# ./flatpak-pip-generator --requirements-file requirements-client.txt --ignore-pkg cffi==1.17.1  --prefer-wheels=ast-serialize --yaml --runtime org.kde.Sdk//6.10
