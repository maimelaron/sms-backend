@echo off
title SMS Backend - Spring Boot (port 8081)
color 0B

echo.
echo  Starting Interface Innovators High School - Backend Server...
echo  Port: 8081
echo  Press Ctrl+C to stop
echo.

cd /d "%~dp0"
mvn spring-boot:run -s settings.xml
