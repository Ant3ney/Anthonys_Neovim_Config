local uv = vim.loop

function driver()
	local dir = vim.fn.getcwd()
	local nvim_path = get_nvim_dir()
	local engine_path = get_engine_path()
	local project_name = get_project_name()
	local ubt_path_project = engine_path .. "\\Engine\\Binaries\\DotNET\\UnrealBuildTool\\UnrealBuildTool.dll"
	local ubt_path_clang = engine_path .. "\\Engine\\Binaries\\DotNET\\UnrealBuildTool\\UnrealBuildTool.exe"
	local output_dir = dir .. "\\DevSpace\\Anthony"
	local path_to_project_file = dir .. "\\" .. project_name .. ".uproject"

	local clang_template = nvim_path .. "\\build_clangd_database_command_template.bat"
	local build_template = nvim_path .. "\\build_project_command_template.bat"
	local nvim_config_path = nvim_path .. "\\template.lua"

	ensure_hierarchy()

	local build_target = dir .. "\\Scripts" .. "\\build_project_command.bat"
	local clang_target = dir .. "\\Scripts" .. "\\build_clangd_database_command.bat"
	local nvim_config_target = dir .. "\\DevSpace\\Anthony" .. "\\.nvim.lua"

	copy_file_from_to(build_template, build_target)
	copy_file_from_to(clang_template, clang_target)
	copy_file_from_to(nvim_config_path, nvim_config_target)

	local ubt_path_delim = "____@@@@ubt_path@@@@____"
	local project_path_delim = "____@@@@project_path@@@@____"
	local project_name_delim = "____@@@@project_name@@@@____"
	local output_dir_delim = "____@@@@output_dir@@@@____"

	replace_string_in_file(build_target, ubt_path_delim, ubt_path_project)
	replace_string_in_file(build_target, project_path_delim, path_to_project_file)
	replace_string_in_file(build_target, project_name_delim, project_name)

	replace_string_in_file(clang_target, ubt_path_delim, ubt_path_clang)
	replace_string_in_file(clang_target, project_path_delim, path_to_project_file)
	replace_string_in_file(clang_target, project_name_delim, project_name)
	replace_string_in_file(clang_target, output_dir_delim, output_dir)

end

function replace_string_in_file(file, string_to_replace, new_string)
	local fd = uv.fs_open(file, "a+", 420)
	local fd_fstat = uv.fs_fstat(fd)
	local data = uv.fs_read(fd, fd_fstat.size, 0)
	data = string.gsub(data, string_to_replace, new_string)
	uv.fs_close(fd)

	fd = uv.fs_open(file, "w+", 420)
	uv.fs_write(fd, data, -1)	
	uv.fs_close(fd)
end

function copy_file_from_to(from, to)
	local fd_from = uv.fs_open(from, "a+", 420)
	local fd_fstat_from = uv.fs_fstat(fd_from)
	local data_from = uv.fs_read(fd_from, fd_fstat_from.size, 0)
	uv.fs_close(fd_from)

	local fd_to = uv.fs_open(to, "w+", 420)
	uv.fs_write(fd_to, data_from)
	uv.fs_close(fd_to)
end

function ensure_hierarchy()
	local dir = vim.fn.getcwd()
	verify_or_create_dir(dir .. "\\Scripts")
	verify_or_create_dir(dir .. "\\DevSpace")
	verify_or_create_dir(dir .. "\\DevSpace\\Anthony")
end

function verify_or_create_dir(dir)
	local fstat = uv.fs_stat(dir)
	if not fstat then
		uv.fs_mkdir(dir, 493)
	end
end

function get_nvim_dir()
	local info = debug.getinfo(1, "S")
	local rough_nvim_dir = info.source
	local dir_n = clean_dir(rough_nvim_dir)
	dir_n = strip_file_name_at_path(dir_n)
	return dir_n
end

function strip_file_name_at_path(path)
	local striped = string.match(path, "(.*)%\\")
	return striped
end


function get_file_name_at_path(path)
	local striped = string.match(path, ".*%\\(.*)")
	return striped
end

function clean_dir(dir)
	local new_dir = string.match(dir, "@(.*)")
	new_dir = string.gsub(new_dir, "%/", "%\\")
	return new_dir;
end

function get_engine_path()
	local version = get_ue_version()
	local cmd = [[reg query "HKLM\SOFTWARE\EpicGames\Unreal Engine\]] .. version .. [[" /v InstalledDirectory]]
	local handle = io.popen(cmd)
	local data = handle.read(handle, "*a")
	local path = string.match(data, "REG_SZ%s+(.*)")
	local path = string.match(path, "(.*)\n\n")
	return path
end

function get_ue_version()
	local dir = vim.fn.getcwd()
	local project_name = get_project_name()
	local file_path_p = dir .. "\\" .. project_name .. ".uproject"

	local fd_p = uv.fs_open(file_path_p, "a+", 420)
	local fstat_p = uv.fs_fstat(fd_p)
	local data_p = uv.fs_read(fd_p, fstat_p.size, 0)
	--local version = string.match(data_p, '%"EngineAssociation%": %"(.*)%",\r\n')
	local version = string.match(data_p, '%"EngineAssociation%": %\"(.?.?.?.?.?.?)')
	version = string.match(version, "(.*)%\"")


	return version
end

function get_project_name()
	local dir = vim.fn.getcwd()
	local req = uv.fs_scandir(dir)
	local uproject_name;
	while true do
		local name, type = uv.fs_scandir_next(req)
		if not name then break end
		local potential_name = string.match(name, "(.*)%.uproject")
		if potential_name then 
			uproject_name = potential_name
			break
		end
	end

	return uproject_name
end

vim.api.nvim_create_user_command("M", driver, {})
