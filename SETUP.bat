@echo off
title Interface Innovators High School - First-Time Setup
color 0A

echo.
echo  ============================================================
echo   Interface Innovators High School - School Management System
echo   First-Time Setup Script
echo  ============================================================
echo.

REM ---------------------------------------------------------------
REM  STEP 0 — Check prerequisites
REM ---------------------------------------------------------------
echo [CHECK] Verifying prerequisites...
echo.

java -version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Java not found. Install Java 17 JDK from:
    echo         https://adoptium.net/
    pause & exit /b 1
)
echo  [OK] Java found

mvn -version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Maven not found. Install Maven 3.9+ from:
    echo         https://maven.apache.org/download.cgi
    echo         Then add it to your PATH.
    pause & exit /b 1
)
echo  [OK] Maven found

node -v >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Node.js not found. Install Node.js 18+ from:
    echo         https://nodejs.org/
    pause & exit /b 1
)
echo  [OK] Node.js found

echo.

REM ---------------------------------------------------------------
REM  STEP 1 — MySQL credentials
REM ---------------------------------------------------------------
echo [STEP 1] MySQL Configuration
echo.
echo  The backend connects to MySQL with these defaults:
echo    Host    : localhost:3306
echo    Username: root
echo    Password: password
echo.
echo  If your MySQL root password is different, you MUST update it in:
echo    sms-backend\src\main\resources\application.properties
echo  Change the line:  spring.datasource.password=password
echo.
set /p MYSQL_PASS=Enter your MySQL root password (press ENTER if it is 'password'):
if "%MYSQL_PASS%"=="" set MYSQL_PASS=password

REM ---------------------------------------------------------------
REM  STEP 2 — Create database
REM ---------------------------------------------------------------
echo.
echo [STEP 2] Creating database 'sms_db'...

mysql -u root -p%MYSQL_PASS% -e "CREATE DATABASE IF NOT EXISTS sms_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Could not connect to MySQL.
    echo         Make sure MySQL is running and the password is correct.
    echo         You can also create the database manually in MySQL Workbench:
    echo           CREATE DATABASE sms_db CHARACTER SET utf8mb4;
    pause & exit /b 1
)
echo  [OK] Database 'sms_db' ready

REM ---------------------------------------------------------------
REM  STEP 3 — Build backend
REM ---------------------------------------------------------------
echo.
echo [STEP 3] Building backend (this may take a minute)...
echo.

cd /d "%~dp0"
call mvn clean install -s settings.xml -q
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Maven build failed. Run the following for details:
    echo         mvn clean install -s settings.xml
    pause & exit /b 1
)
echo  [OK] Backend built successfully

REM ---------------------------------------------------------------
REM  STEP 4 — Install frontend dependencies
REM ---------------------------------------------------------------
echo.
echo [STEP 4] Installing frontend dependencies...
echo.

REM  Adjust this path if your frontend folder is in a different location
set FRONTEND_DIR=%~dp0..\school-manager-frontend
if not exist "%FRONTEND_DIR%\package.json" (
    set /p FRONTEND_DIR=Frontend folder not found. Enter the full path to school-manager-frontend:
)

cd /d "%FRONTEND_DIR%"
call npm install --silent
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] npm install failed. Try running 'npm install' manually in the frontend folder.
    pause & exit /b 1
)
echo  [OK] Frontend dependencies installed

REM ---------------------------------------------------------------
REM  STEP 5 — Done
REM ---------------------------------------------------------------
echo.
echo  ============================================================
echo   Setup Complete!
echo  ============================================================
echo.
echo   NEXT STEPS:
echo.
echo   1. Start the backend:
echo      - Open a terminal in the sms-backend folder
echo      - Run:  START-BACKEND.bat
echo.
echo   2. Start the frontend (in a SEPARATE terminal):
echo      - Run:  START-FRONTEND.bat
echo.
echo   3. Seed the database (first run only):
echo      - Wait for the backend to fully start
echo      - Open MySQL Workbench, select 'sms_db'
echo      - Run the SQL in:  src\main\resources\db\data.sql
echo.
echo   4. Open your browser at:  http://localhost:5173
echo.
echo   LOGIN CREDENTIALS (after seeding):
echo     Admin  : admin@school.ac.za  /  Admin@123
echo     Parent : james@parent.com    /  Parent@123
echo.
echo  ============================================================
echo.
pause
