setlocal

set project_path=____@@@@project_path@@@@____
set project_name=____@@@@project_name@@@@____
set ubt_path=____@@@@ubt_path@@@@____

powershell -noprofile -command "dotnet \"\"\"%ubt_path%\"\"\" -project="%project_path%" "%project_name%Editor" development win64 -waitmutex -frommsbuild -arcitecture=x64

endlocal
