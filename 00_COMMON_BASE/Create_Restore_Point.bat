@echo off
REM ============================================================
REM 00_COMMON_BASE: создать точку восстановления системы ПЕРЕД твиками.
REM (в старом наборе отсутствовала — обязательный шаг!)
REM ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Запустите от имени администратора.
    pause
    exit /b 1
)

powershell -NoProfile -Command "Checkpoint-Computer -Description 'CS2 Tweaks Pack v2 - before apply' -RestorePointType MODIFY_SETTINGS"
echo.
echo Точка восстановления создана (если служба защиты системы включена).
pause
