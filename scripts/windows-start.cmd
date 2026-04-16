@echo off
setlocal enabledelayedexpansion

set "ROOT_DIR=%~dp0.."
for %%I in ("%ROOT_DIR%") do set "ROOT_DIR=%%~fI"
set "BIN_PATH=%ROOT_DIR%\bin\meo2cpa.exe"
set "CONFIG_PATH=%ROOT_DIR%\config.yaml"
set "AUTH_PATH=%ROOT_DIR%\auths"
set "LOG_PATH=%ROOT_DIR%\logs"
set "RUN_PATH=%ROOT_DIR%\run"
set "PANEL_PATH=%ROOT_DIR%\panel"
set "TMP_PATH=%ROOT_DIR%\tmp"
set "PID_FILE=%RUN_PATH%\meo2cpa.pid"
set "STDOUT_LOG=%LOG_PATH%\meo2cpa.out.log"
set "STDERR_LOG=%LOG_PATH%\meo2cpa.err.log"

if not exist "%CONFIG_PATH%" (
  echo Config not found: "%CONFIG_PATH%"
  echo Run scripts\windows-bootstrap.cmd first.
  exit /b 1
)

if not exist "%BIN_PATH%" (
  echo Binary not found: "%BIN_PATH%"
  echo Run scripts\windows-bootstrap.cmd first.
  exit /b 1
)

if not exist "%AUTH_PATH%" mkdir "%AUTH_PATH%"
if not exist "%LOG_PATH%" mkdir "%LOG_PATH%"
if not exist "%RUN_PATH%" mkdir "%RUN_PATH%"
if not exist "%PANEL_PATH%" mkdir "%PANEL_PATH%"
if not exist "%TMP_PATH%" mkdir "%TMP_PATH%"

if exist "%PID_FILE%" (
  set /p EXISTING_PID=<"%PID_FILE%"
  tasklist /FI "PID eq !EXISTING_PID!" | find "!EXISTING_PID!" >nul 2>nul
  if not errorlevel 1 (
    echo Meo2cpa is already running with PID !EXISTING_PID!
    exit /b 0
  )
  del "%PID_FILE%" >nul 2>nul
)

set "WRITABLE_PATH=%PANEL_PATH%"
set "MEO2CPA_ROOT=%ROOT_DIR%"
set "MEO2CPA_PROJECT_ROOT=%ROOT_DIR%"
set "MEO2CPA_PANEL_PATH=%PANEL_PATH%"
set "TMP=%TMP_PATH%"
set "TMPDIR=%TMP_PATH%"

powershell -NoProfile -Command "$p = Start-Process -FilePath '%BIN_PATH%' -ArgumentList '--config','%CONFIG_PATH%' -RedirectStandardOutput '%STDOUT_LOG%' -RedirectStandardError '%STDERR_LOG%' -PassThru; Set-Content -Path '%PID_FILE%' -Value $p.Id"
if errorlevel 1 exit /b 1

set /p NEW_PID=<"%PID_FILE%"
echo Meo2cpa started with PID %NEW_PID%
echo config: %CONFIG_PATH%
echo stdout: %STDOUT_LOG%
echo stderr: %STDERR_LOG%
echo status: scripts\windows-status.cmd
exit /b 0
