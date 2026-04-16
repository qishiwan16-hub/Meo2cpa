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

if not exist "%AUTH_PATH%" mkdir "%AUTH_PATH%"
if not exist "%LOG_PATH%" mkdir "%LOG_PATH%"
if not exist "%RUN_PATH%" mkdir "%RUN_PATH%"
if not exist "%PANEL_PATH%" mkdir "%PANEL_PATH%"
if not exist "%TMP_PATH%" mkdir "%TMP_PATH%"
if not exist "%ROOT_DIR%\bin" mkdir "%ROOT_DIR%\bin"

where go >nul 2>nul
if errorlevel 1 (
  echo Go is not installed or not in PATH.
  exit /b 1
)

if not exist "%CONFIG_PATH%" (
  copy /Y "%ROOT_DIR%\config.example.yaml" "%CONFIG_PATH%" >nul
  echo Config initialized: "%CONFIG_PATH%"
)

echo Building Meo2cpa for Windows...
if not defined GOPROXY set "GOPROXY=https://goproxy.cn,direct"
if defined HTTP_PROXY echo HTTP_PROXY=%HTTP_PROXY%
if defined HTTPS_PROXY echo HTTPS_PROXY=%HTTPS_PROXY%
echo GOPROXY=%GOPROXY%
go build -o "%BIN_PATH%" ./cmd/server
if errorlevel 1 (
  echo Build failed with GOPROXY=%GOPROXY%
  exit /b 1
)

echo Windows install completed.
echo.
echo root: %ROOT_DIR%
echo config: %CONFIG_PATH%
echo bin: %BIN_PATH%
echo.
echo Next step:
echo   scripts\windows-start.cmd
exit /b 0
