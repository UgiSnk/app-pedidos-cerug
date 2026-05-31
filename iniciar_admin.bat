@echo off
title Servidor Admin - Component New House
echo ==========================================================
echo 🚀 Iniciando servidor local para el Portal Administrador...
echo ==========================================================
echo.
echo URL: http://localhost:8090
echo.
echo [INFO] Abriendo tu navegador de internet por defecto...
start http://localhost:8090
echo.
echo [INFO] Servidor corriendo. Presiona Ctrl + C para detenerlo.
npx -y http-server admin -p 8090 -c-1

