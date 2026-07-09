@echo off
title AssetCollector v1.0

cd /d "%~dp0"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\AssetCollector.ps1"

start "" "%~dp0Output"

echo.
echo ==========================================
echo          PROCESO FINALIZADO
echo ==========================================
echo.
pause