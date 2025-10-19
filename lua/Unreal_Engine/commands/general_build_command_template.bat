@echo off
setlocal

rem set project directory and paths
set project_dir=_____@@@PROJECT_DIR@@@_____
set ubt_path=_____@@@UBT_PATH@@@_____
set project_name=_____@@@PROJECT_NAME@@@_____
set uproject_path=%project_dir%\%project_name%.uproject

powershell -noprofile -command "dotnet \"\"\"%ubt_path%\"\"\" "%project_name%" win64 development -project="%uproject_path%" -waitmutex -frommsbuild -architecture=x64"

endlocal
