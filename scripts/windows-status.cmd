@echo off
setlocal

set "ROOT_DIR=%~dp0.."
for %%I in ("%ROOT_DIR%") do set "ROOT_DIR=%%~fI"
set "RUN_PATH=%ROOT_DIR%\run"
set "LOG_PATH=%ROOT_DIR%\logs"
set "PID_FILE=%RUN_PATH%\meo2cpa.pid"
set "STDOUT_LOG=%LOG_PATH%\meo2cpa.out.log"
set "STDERR_LOG=%LOG_PATH%\meo2cpa.err.log"

if not exist "%PID_FILE%" (
  echo status=stopped
  exit /b 0
)

set /p PID=<"%PID_FILE%"
tasklist /FI "PID eq %PID%" | find "%PID%" >nul 2>nul
if not errorlevel 1 (
  echo status=running
  echo pid=%PID%
  echo stdout_log=%STDOUT_LOG%
  echo stderr_log=%STDERR_LOG%
  exit /b 0
)

del "%PID_FILE%" >nul 2>nul
echo status=stale-pid-removed
exit /b 0
