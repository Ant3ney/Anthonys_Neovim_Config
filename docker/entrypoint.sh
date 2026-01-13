#!/usr/bin/env bash
set -euo pipefail

# If the user mounted an empty volume at stdpath("data"), plugins may be missing.
# This entrypoint attempts a best-effort sync before starting Neovim.

NVIM_CONFIG_DIR="${NVIM_CONFIG_DIR:-/home/dev/.config/nvim}"
PACKER_LUA="${NVIM_CONFIG_DIR}/lua/Unreal_Engine/packer.lua"

if [[ -f "${PACKER_LUA}" ]]; then
  nvim --headless \
    -c "lua pcall(dofile, '${PACKER_LUA}')" \
    -c "PackerSync" \
    -c "autocmd User PackerComplete quitall" \
    >/dev/null 2>&1 || true

  # Second pass for good measure.
  nvim --headless \
    -c "lua pcall(dofile, '${PACKER_LUA}')" \
    -c "PackerSync" \
    -c "autocmd User PackerComplete quitall" \
    >/dev/null 2>&1 || true
fi

exec "$@"

