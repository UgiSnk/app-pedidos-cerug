@echo off
title Cliente App - Component New House
echo ==========================================================
echo 🚀 Iniciando la App Cliente en Flutter (Localhost:8081)...
echo ==========================================================
echo.
echo URL: http://localhost:8081/?vendedorID=vendedor_component
echo.
echo [INFO] Compilando y abriendo Chrome de forma nativa...
flutter run -d chrome --web-renderer html --web-port 8081
