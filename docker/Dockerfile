# syntax=docker/dockerfile:1

# Neovim dev container that bakes in this repo as the nvim config.
#
# Notes:
# - We vendor packer.nvim at build time and run PackerSync headless multiple times
#   because some plugins require a second sync after initial bootstrap.
# - Plugin state is placed under /home/dev/.local/share/nvim (standard stdpath("data")).

FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

# Core packages
# - neovim: editor
# - git: packer + plugins
# - make/g++/python3: common plugin build/runtime needs (treesitter, native builds)
# - nodejs/npm: tsserver + many JS-based tools
# - ripgrep/fd-find: telescope + general searching
# - ca-certificates: TLS
# - curl: misc tooling (not required for build, but useful in dev container)
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    neovim \
    make \
    g++ \
    python3 \
    python3-pip \
    nodejs \
    npm \
    ripgrep \
    fd-find \
    unzip \
    xz-utils \
    curl \
    locales \
  && rm -rf /var/lib/apt/lists/*

# Ensure `fd` exists (Ubuntu packages fd as `fdfind`).
RUN if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then ln -s "$(command -v fdfind)" /usr/local/bin/fd; fi

# UTF-8 locale
RUN sed -i 's/^# \(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen \
  && locale-gen
ENV LANG=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8

# Non-root user
RUN useradd -m -s /bin/bash dev
USER dev
WORKDIR /home/dev

# Prepare config + data dirs
RUN mkdir -p /home/dev/.config/nvim \
  && mkdir -p /home/dev/.local/share/nvim \
  && mkdir -p /home/dev/.cache/nvim

# Copy this repo into the container as the Neovim config
# (docker build context should be the repo root)
COPY --chown=dev:dev . /home/dev/.config/nvim/

# Install packer.nvim (bootstrap happens inside your packer.lua too, but doing it here
# makes builds more deterministic).
RUN git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  /home/dev/.local/share/nvim/site/pack/packer/start/packer.nvim

# Install TypeScript language server (your config enables vim.lsp.enable('ts'))
RUN npm install -g typescript typescript-language-server

# Bootstrap plugins headlessly.
# We run multiple cycles to match your manual workflow (:so then :PackerSync a few times).
#
# Important:
# - We source lua/Unreal_Engine/packer.lua explicitly.
# - Then we run :PackerSync and wait for it to finish.
# - Re-run to ensure post-install hooks/build steps settle.
RUN nvim --headless \
  -c "lua pcall(dofile, vim.fn.stdpath('config') .. '/lua/Unreal_Engine/packer.lua')" \
  -c "PackerSync" \
  -c "autocmd User PackerComplete quitall" \
  || true

RUN nvim --headless \
  -c "lua pcall(dofile, vim.fn.stdpath('config') .. '/lua/Unreal_Engine/packer.lua')" \
  -c "PackerSync" \
  -c "autocmd User PackerComplete quitall" \
  || true

RUN nvim --headless \
  -c "lua pcall(dofile, vim.fn.stdpath('config') .. '/lua/Unreal_Engine/packer.lua')" \
  -c "PackerSync" \
  -c "autocmd User PackerComplete quitall" \
  || true

# Entry point to ensure plugins stay synced in case you mount a different config or start fresh volumes.
COPY --chown=dev:dev docker/entrypoint.sh /usr/local/bin/nvim-dev-entrypoint
RUN chmod +x /usr/local/bin/nvim-dev-entrypoint

ENTRYPOINT ["/usr/local/bin/nvim-dev-entrypoint"]
CMD ["nvim"]

