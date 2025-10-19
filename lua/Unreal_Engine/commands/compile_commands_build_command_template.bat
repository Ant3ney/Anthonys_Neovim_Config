@echo off
setlocal

set project_dir=_____@@@PROJECT_DIR@@@_____
set ubt_path=_____@@@UBT_PATH@@@_____
set project_name=_____@@@PROJECT_NAME@@@_____
set uproject_path=%PROJECT_DIR%\%PROJECT_NAME%.uproject
set dev_space_dir=_____@@@DEV_SPACE_DIR@@@_____

"%ubt_path%" -mode=generateclangdatabase -project="%uproject_path%" -game -engine -outputdir="%dev_space_dir%" "%project_name%"Editor win64

endlocal
