#!/usr/bin/env bash

cYT_DLP=($(curl -s https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest | jq -r '.assets[] | select (.browser_download_url | contains(".tar.gz")) | .digest, .browser_download_url'))
export YT_DLP_SHA=$(echo ${YT_DLP[0]} | cut -d : -f 2)
export YT_DLP_URL=${YT_DLP[1]}

YT_DLP_EJS=($(curl -s https://api.github.com/repos/yt-dlp/ejs/releases/latest | jq -r '.assets[] | select (.browser_download_url | contains("py3-none-any.whl")) | .digest, .browser_download_url'))
export YT_DLP_EJS_SHA=$(echo ${YT_DLP_EJS[0]} | cut -d : -f 2)
export YT_DLP_EJS_URL=${YT_DLP_EJS[1]}
DENO_AARCH64=($(curl -s https://api.github.com/repos/denoland/deno/releases/latest | jq -r '.assets[] | select(.browser_download_url | contains("aarch64") and contains("deno-") and contains("linux") and contains(".zip") and (contains("sha256sum")|not)) | .digest, .browser_download_url'))
export DENO_AARCH64_SHA=$(echo ${DENO_AARCH64[0]} | cut -d : -f 2)
export DENO_AARCH64_URL=${DENO_AARCH64[1]}

DENO_X86_64=($(curl -s https://api.github.com/repos/denoland/deno/releases/latest | jq -r '.assets[] | select(.browser_download_url | contains("x86_64") and contains("deno-") and contains("linux") and contains(".zip") and (contains("sha256sum")|not)) | .digest, .browser_download_url'))
export DENO_X86_64_SHA=$(echo ${DENO_AARCH64[0]} | cut -d : -f 2)
export DENO_X86_64_URL=${DENO_AARCH64[1]}

export SYNG_COMMIT=$(git log -1 --format=%H)
envsubst '$YT_DLP_URL $YT_DLP_SHA $YT_DLP_EJS_URL $YT_DLP_EJS_SHA $DENO_AARCH64_SHA $DENO_AARCH64_URL $DENO_X86_64_SHA $DENO_X86_64_URL $SYNG_COMMIT' < rocks.syng.Syng.yaml.template > rocks.syng.Syng.yaml

./flatpak-pip-generator --yaml setuptools_scm[toml] # for argon2-cffi-bindings
./flatpak-pip-generator --yaml --pyproject-file ../../pyproject.toml --ignore-pkg=PySide6 --prefer-wheels=uv-build,pillow,pymediainfo --optdep-groups client --runtime org.kde.Sdk//6.10
