@echo off
setlocal

REM Set project directory and paths
set PROJECT_DIR=_____@@@PROJECT_DIR@@@_____
set UBT_PATH=_____@@@UBT_PATH@@@_____
set UPROJECT_PATH="%PROJECT_DIR%\_____@@@PROJECT_NAME@@@_____.uproject"
set LOG_FILE=%PROJECT_DIR%\BuildLog.txt

REM Change to the project directory
cd /d "%PROJECT_DIR%"

REM Check if dotnet is installed
where dotnet >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ❌ 'dotnet' is not in your PATH. Install the .NET SDK or add it to your PATH.
    pause
    exit /b 1
)

echo 🔧 Starting build... (output will be logged to BuildLog.txt)
echo. > "%LOG_FILE%"

REM Run UnrealBuildTool via dotnet and log output
powershell -NoLogo -NoProfile -Command ^
    "& { dotnet \"\"\"%UBT_PATH%\"\"\" Strafing_SystemEditor Win64 Development -Project=%UPROJECT_PATH% -WaitMutex -FromMsBuild -architecture=x64 2>&1 | Tee-Object -FilePath '%LOG_FILE%' }"


endlocal
