setlocal
set ubt_path=____@@@@ubt_path@@@@____
set project_path=____@@@@project_path@@@@____
set project_name=____@@@@project_name@@@@____
set output_dir=____@@@@output_dir@@@@____

powershell -noprofile -command "dotnet \"\"\"%ubt_path%\"\"\" -project="%project_path%" "%project_name%Editor" development win64 -waitmutex -frommsbuild -arcitecture=x64"

setlocal
