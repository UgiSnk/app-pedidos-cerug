@echo off
cd /d "%~dp0"
title Servidor Admin - Pedidos Ropa Matias
echo ==========================================================
echo 🚀 Iniciando servidor local para el Portal Administrador...
echo ==========================================================
echo.
echo URL: http://localhost:8085
echo.
echo [INFO] Abriendo tu navegador de internet por defecto...
start http://localhost:8085
echo.
echo [INFO] Servidor corriendo. Presiona Ctrl + C para detenerlo.
npx -y http-server admin -p 8085 -c -1

