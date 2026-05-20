@echo off
title SMS Frontend - Vite (port 5173)
color 0E

echo.
echo  Starting Interface Innovators High School - Frontend...
echo  URL: http://localhost:5173
echo  Press Ctrl+C to stop
echo.

REM Adjust this path if your frontend folder is in a different location
set FRONTEND_DIR=%~dp0..\school-manager-frontend

if not exist "%FRONTEND_DIR%\package.json" (
    set /p FRONTEND_DIR=Frontend folder not found. Enter the full path to school-manager-frontend:
)

cd /d "%FRONTEND_DIR%"
npm run dev
