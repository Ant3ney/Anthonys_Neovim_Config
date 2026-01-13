# Neovim config Docker image

This builds a Docker image that contains your Neovim configuration and bootstraps plugins via **packer.nvim**.

It intentionally runs **PackerSync multiple times** in the Docker build and once again on container start, because your config often needs `:so` + `:PackerSync` a few times to fully settle.

## Build

From the repo root:

```bash
docker build -f docker/Dockerfile -t anthony-nvim:latest .
```

## Run

### Minimal interactive terminal

```bash
docker run --rm -it anthony-nvim:latest
```

### Persist plugins/cache across container runs (recommended)

```bash
docker volume create nvim-data

docker run --rm -it \
  -v nvim-data:/home/dev/.local/share/nvim \
  anthony-nvim:latest
```

### Mount a project directory into the container

```bash
docker run --rm -it \
  -v "$PWD":/work \
  -w /work \
  -v nvim-data:/home/dev/.local/share/nvim \
  anthony-nvim:latest
```

## Avante API key

Your config expects the OpenAI key in `AVANTE_OPENAI_API_KEY`.

Example:

```bash
docker run --rm -it \
  -e AVANTE_OPENAI_API_KEY="sk-..." \
  -v nvim-data:/home/dev/.local/share/nvim \
  anthony-nvim:latest
```

## Notes

- Image uses a non-root user: `dev`.
- `typescript-language-server` is installed globally in the image because your config enables the `ts` LSP.
- `clangd` is expected to come from the distro (`clangd` binary). If you want it pinned or newer, we can install LLVM clangd explicitly.

