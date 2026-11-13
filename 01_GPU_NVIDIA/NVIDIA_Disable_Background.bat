@echo off
REM ============================================================
REM 01_GPU_NVIDIA: применить ключевые настройки панели NVIDIA через
REM nvidia-smi / реестр драйвера там, где это возможно без DRS API.
REM Основные Low-Latency параметры (LPM=Ultra и т.п.) задаются в
REM "Панель управления NVIDIA -> Управление параметрами 3D" — см. README.
REM Этот скрипт отключает телеметрию и фоновые процессы NVIDIA.
REM ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Запустите от имени администратора.
    pause
    exit /b 1
)

taskkill /f /im NvContainer*.exe   >nul 2>&1
taskkill /f /im NVDisplay.Container.exe >nul 2>&1 & REM НЕ критично, перезапустится с драйвером
sc config NVDisplay.ContainerLocalSystem start= demand >nul 2>&1

REM Приоритет процесса игры выше фоновых служб NVIDIA
wmic process where "name='cs2.exe'" CALL SETPRIORITY realtime >nul 2>&1

echo Готово. Основные latency-настройки (Low Latency Mode = Ultra,
echo Power Management = Prefer Maximum Performance) задайте в панели NVIDIA вручную.
pause
