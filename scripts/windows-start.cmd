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

set "WRITABLE_PATH=%PANEL_PATH%"
set "MEO2CPA_ROOT=%ROOT_DIR%"
set "MEO2CPA_PROJECT_ROOT=%ROOT_DIR%"
set "MEO2CPA_PANEL_PATH=%PANEL_PATH%"
set "TMP=%TMP_PATH%"
set "TMPDIR=%TMP_PATH%"

echo Meo2cpa starting in foreground
echo config: %CONFIG_PATH%
echo stop: Ctrl+C

"%BIN_PATH%" --config "%CONFIG_PATH%"
exit /b %errorlevel%
