@echo off
setlocal

REM Set project directory and paths
set PROJECT_DIR=_____@@@PROJECT_DIR@@@_____
set UBT_PATH=_____@@@UBT_PATH@@@_____
set PROJECT_NAME=_____@@@PROJECT_NAME@@@_____
set UPROJECT_PATH=%PROJECT_DIR%\%PROJECT_NAME%.uproject
set DEV_SPACE_DIR=_____@@@DEV_SPACE_DIR@@@_____

echo 🔧 Starting Compile Commands build... 

REM 
    "%UBT_PATH%" -mode=GenerateClangDatabase -project="%UPROJECT_PATH%" -game -engine -OutputDir="%DEV_SPACE_DIR%" %PROJECT_NAME%Editor Development Win64 && move /Y "%PROJECT_DIR%\compile_commands.json" "%PROJECT_DIR%\DevSpace\Anthony\compile_commands.json"

endlocal
