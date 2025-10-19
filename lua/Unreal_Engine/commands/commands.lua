local uv = vim.loop

local test_delete_me_workspace = "C:\\Users\\antho\\AppData\\Local\\nvim\\lua\\Unreal_Engine\\commands\\test_workspace"

function init_UE_nvim_ENV() 
	local project_dir = vim.fn.getcwd()
	local ue_engine_path = get_unreal_engine_path("5.6")
	local project_name = find_uproject(project_dir)
	local UBT_EXTENSION = "\\Engine\\Binaries\\DotNET\\UnrealBuildTool\\UnrealBuildTool.dll" 
	local ubt_path = ue_engine_path .. UBT_EXTENSION

	if not validate_and_make_hierarchy(project_dir) then
		print("could not create valid hierarchy")
		return
	end

	print("project_dir: " .. project_dir)
	print("ue_engine_path: " .. (ue_engine_path or "not found"))
	print("project_name: " .. (project_name or "not found"))
	print("ubt_path: " .. (ubt_path or "not found"))
	
	local test_workspace_dir = get_path_to_this_file() .. "\\test_workspace"
	local general_build_command_template_dir = get_path_to_this_file() .. "\\general_build_command_template.bat"
	local general_build_command_template_text = get_file_text(general_build_command_template_dir)

	local new_build_command_template_text = string.gsub(general_build_command_template_text, "_____@@@PROJECT_DIR@@@_____", project_dir)
	new_build_command_template_text = string.gsub(new_build_command_template_text, "_____@@@UBT_PATH@@@_____", ubt_path)
	new_build_command_template_text = string.gsub(new_build_command_template_text, "_____@@@PROJECT_NAME@@@_____", project_name)

	wright_to_file_and_overide(new_build_command_template_text, project_dir .. "\\Scripts" .. "\\general_build_command.bat")

	local ubt_path_compile_commands = ue_engine_path .. "\\Engine\\Binaries\\DotNET\\UnrealBuildTool\\UnrealBuildTool.exe"
	local dev_space_dir = project_dir .. "\\DevSpace\\Anthony"

	local compile_commands_build_command_template_dir = get_path_to_this_file() .. "\\compile_commands_build_command_template.bat"
	local compile_commands_build_command_template_text = get_file_text(compile_commands_build_command_template_dir)

	local new_compile_commands_build_command_template_text = string.gsub(compile_commands_build_command_template_text, "_____@@@PROJECT_DIR@@@_____", project_dir)
	new_compile_commands_build_command_template_text = string.gsub(new_compile_commands_build_command_template_text, "_____@@@UBT_PATH@@@_____", ubt_path_compile_commands)
	new_compile_commands_build_command_template_text = string.gsub(new_compile_commands_build_command_template_text, "_____@@@PROJECT_NAME@@@_____", project_name)
	new_compile_commands_build_command_template_text = string.gsub(new_compile_commands_build_command_template_text, "_____@@@DEV_SPACE_DIR@@@_____", dev_space_dir)

	wright_to_file_and_overide(new_compile_commands_build_command_template_text, project_dir .. "\\Scripts" .. "\\compile_commands_build_command.bat")


	local local_nvim_config_template_dir = get_path_to_this_file() .. "\\template.nvim.lua"
	local local_nvim_config_template_text = get_file_text(local_nvim_config_template_dir)

	local new_local_nvim_config_template_text = string.gsub(local_nvim_config_template_text, "_____@@@PROJECT_NAME@@@_____", project_name)

	wright_to_file_and_overide(new_local_nvim_config_template_text, dev_space_dir .. "\\.nvim.lua")
end


vim.api.nvim_create_user_command('UEI', init_UE_nvim_ENV, {})

print("Finished configuring unreal engine commands")

-- ============ Helpers ============

function wright_to_file_and_overide(content, full_file_path)


	local stat = uv.fs_stat(full_file_path)
	if stat then
		uv.fs_unlink(full_file_path)
	end

	local fd = uv.fs_open(full_file_path, "w", 420)
	uv.fs_write(fd, content, -1)
	uv.fs_close(fd)
end


function get_file_text(dir)
	local file_handle = io.open(dir, "r")
	local content = file_handle.read(file_handle, "*a")
	return content
end

function validate_and_make_hierarchy(project_dir)
	local scripts_dir_is_validated = mkdir_if_not_already_there(project_dir .. "\\Scripts")
	if not scripts_dir_is_validated then
		print("Scripts dir is invalid")
		return nil
	end

	local dev_space_dir_is_validated = mkdir_if_not_already_there(project_dir .. "\\DevSpace") 
	if not dev_space_dir_is_validated then
		print("Dev space dir is invalid")
		return nil
	end

	-- For now, the user is hardcoded to my name
	local user_dir_is_validated = mkdir_if_not_already_there(project_dir .. "\\DevSpace\\Anthony") 
	if not user_dir_is_validated then
		print("User dir is invalid")
		return nil
	end

	return true
end

function mkdir_if_not_already_there(full_path_dir)
	full_path_dir = make_path_all_backslashes(full_path_dir)
	local new_dir_name = select(3, string.match(full_path_dir, "(.*)([%\\](.*))"))
	local base_dir = string.match(full_path_dir, "([^\r\n]+)(%\\)")
	local req = uv.fs_scandir(base_dir)
	if not req then return nil end
	local had_new_dir = false;

	while true do
		local name, typ = uv.fs_scandir_next(req)
		if not name then break end
		if typ == "directory" then
			if name == new_dir_name then
				had_new_dir = true
				break
			end
		end
	end

	if had_new_dir == false then
		print(base_dir .. "\\" .. new_dir_name)
		local ok, err = uv.fs_mkdir(base_dir .. "\\" .. new_dir_name, 493)	
		if not ok then
			print("Failed to make scripts dir because " .. err)
			return nil 
		end
	end

	return true
end

function make_path_all_backslashes(path)
	return 	string.gsub(path, "[%/]", "%\\")
end

function get_path_to_this_file()
	local info = debug.getinfo(2, "S")
	local source = info.source
	source = make_path_all_backslashes(source)
	source = string.match(source, "([^%@].*)([%\\])")
	return source
end




function get_unreal_engine_path(version)
  -- Query registry for InstalledDirectory
  local cmd = string.format(
    [[reg query "HKLM\SOFTWARE\EpicGames\Unreal Engine\%s" /v InstalledDirectory]],
    version
  )

  local handle = io.popen(cmd)
  if not handle then
    return nil
  end

  local result = handle:read("*a")
  handle:close()

  -- Extract the path from the result
  local path = result:match("InstalledDirectory%s+REG_SZ%s+([^\r\n]+)")
  return path
end

function find_uproject(dir)
	local req = uv.fs_scandir(dir)
	if not req then return nil end
	
	while true do 
		local name, typ = uv.fs_scandir_next(req)
		if not name then break end
		if typ == "file" then
			matched = string.match(name, "(.*)(%.uproject)")
			if matched then
				return matched
			end
		end
	end
end




