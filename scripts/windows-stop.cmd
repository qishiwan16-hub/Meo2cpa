@echo off
setlocal

set "ROOT_DIR=%~dp0.."
for %%I in ("%ROOT_DIR%") do set "ROOT_DIR=%%~fI"
set "RUN_PATH=%ROOT_DIR%\run"
set "PID_FILE=%RUN_PATH%\meo2cpa.pid"

if not exist "%PID_FILE%" (
  echo Meo2cpa is not running
  exit /b 0
)

set /p PID=<"%PID_FILE%"
if "%PID%"=="" (
  del "%PID_FILE%" >nul 2>nul
  echo Removed empty PID file
  exit /b 0
)

taskkill /PID %PID% /T >nul 2>nul
if errorlevel 1 (
  del "%PID_FILE%" >nul 2>nul
  echo Process not found, stale PID removed
  exit /b 0
)

del "%PID_FILE%" >nul 2>nul
echo Meo2cpa stopped
exit /b 0
