uv = vim.loop

function driver()
	print("this is the driver")
	local project_name = get_poject_name()
	local engine_path = get_engine_path()
	local dir_n = debug.getinfo(1, "S").source
	print(dir_n)
end

function get_poject_name()
	local dir = vim.fn.getcwd()
	local req = uv.fs_scandir(dir) 

	local project_name
	while true do
		local name = uv.fs_scandir_next(req)
		if not name then break end
		project_name = 	string.match(name, "(.*)%.uproject")
		if project_name then break end

	end

	return project_name
end

function get_engine_path()
	local engine_version = get_engine_version()
	local get_engine_path_command = [[reg query "HKLM\SOFTWARE\EpicGames\Unreal Engine\]] .. engine_version .. [[" /v InstalledDirectory]]
	local handle = io.popen(get_engine_path_command)
	local data = handle.read(handle, "*a")
	local path = string.match(data, "REG_SZ%s*(.*)")
	path = string.match(path, "(.*)\n\n")
	return path
end

function get_engine_version()
	local project_name = get_poject_name()
	local dir = vim.fn.getcwd()
	local project_path = dir .. project_name .. ".uproject"
	local fs_p = uv.fs_open(dir .. "\\" .. project_name .. ".uproject", "a+", 420)
	local fs_fstat_p = uv.fs_fstat(fs_p)
	local data = uv.fs_read(fs_p, fs_fstat_p.size, 0)
	print("data_below")
	
	print(data)

	--version = string.gsub('hello', "hell", "n")
	--print(version)
	version = string.match(data, "EngineAssociation%\": %\"(.?.?.?.?.?)")
	version = string.match(data, "[1-9]+%.[1-9]+")

	print(version .. " no new line plese")

	print(project_path)

	return version
end

vim.api.nvim_create_user_command("M", driver, {})



print("this is the module practice")
