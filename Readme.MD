# Anthonys Nvim Config 


## Docker dev environment

A Docker image definition is included under `docker/`.

- Build: `docker build -f docker/Dockerfile -t anthony-nvim:latest .`
- Run: `docker run --rm -it anthony-nvim:latest`
- Persist plugins: `docker volume create nvim-data && docker run --rm -it -v nvim-data:/home/dev/.local/share/nvim anthony-nvim:latest`

More details: `docker/README.md`

## Avante
AI will tell you to run this...
```bash
cd ~/.local/share/nvim/site/pack/packer/start/avante.nvim
make
```

Don't run it. It will make avante ignore your config files. If you run it, go to the ~/.config dir and delete the avante.nvim or whatever config file there is. Run packer sync again and avante will listen to you configs in the after dir or the packer install file

Also make sure to set your open ai API key
```bash
export AVANTE_OPENAI_API_KEY="sk-xxxxxxxxxxxxxxxx"
```


# Feature TODO list
- [x] Basic c++ LSP  
- [X] Command to generate Unreal Engine and Project source awareness in LSP
- [X] Make compile_comands.json file generation bound to <leader v b>
- [X] Make normal unreal engine build command bound to <C-b>
- [ ] Make clean build bound to <leader c b b> Hard to click on axident
- [x] Go to definition / Peek difinition
- [X] Run scripts via hotkeys
- [ ] Project specific hotkeys with scripts
- [ ] Global confic hotkeys with scripts
- [X] Intigrated Chat GPT
- [ ] Conventional snipits
- [ ] UE log snipit
- [ ] if statement macro snipit
- [ ] Easy way to view build logs after leaving terminal
- [ ] A note page file that can be opened via hotkeys. Unique per project and one global note
- [ ] Build logs with color
- [ ] Build logs that tell you if build was successfull or not in color
- [ ] More harpoon hotkeys
- [X] Learn vim split schreen
- [ ] Remove cap lock functionality unless hotkey reactivates it
- [ ] Ability to cancel a build in progress
