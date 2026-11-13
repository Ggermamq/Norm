@echo off
REM ============================================================
REM 11_POWER_PLANS: включить скрытый план "Ultimate Performance"
REM и сделать его активным. Затем импортировать игровой план (Game Plan),
REM если файл .pow рядом. Из старого набора ("2 Открывать pow файлы.reg" —
REM теперь не нужен, powercfg работает сам).
REM Откат: powercfg /setactive SCHEME_ORIGINAL (или сбалансированный GUID)
REM ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Запустите от имени администратора.
    pause
    exit /b 1
)

REM Ultimate Performance GUID
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>nul
if %errorlevel% equ 0 (
    powercfg -changename e9a42b02-d5df-448d-aa00-03f14749eb61 "CS2 Ultimate" "Max FPS plan"
    powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
    echo План "Ultimate Performance" активирован.
) else (
    echo Ultimate недоступен на этой редакции Windows, оставляем текущий план.
)

REM Импортировать локальный .pow, если положен рядом
if exist "%~dp0CS2_GamePlan.pow" (
    powercfg -import "%~dp0CS2_GamePlan.pow" 
    echo Игровой план импортирован. Выберите его в "Электропитание".
)

pause
