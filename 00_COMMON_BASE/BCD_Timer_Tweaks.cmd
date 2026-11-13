@echo off
REM ============================================================
REM 00_COMMON_BASE: BCD-таймеры (из старого "BCDEdit Tweaks.cmd",
REM исправлено: правильные флаги /set, добавлены проверка админа и откат)
REM useplatformtick yes + disabledynamictick yes = стабильный тик ядра,
REM меньше микрофризов. Откат: _RESTORE\Restore_BCD.bat
REM ЗАПУСКАТЬ ОТ АДМИНИСТРАТОРА!
REM ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Нужны права администратора. Запустите "От имени администратора".
    pause
    exit /b 1
)

bcdedit /set disabledynamictick yes
bcdedit /set useplatformtick yes
bcdedit /set tsctimerpolicy 1

echo.
echo Готово. Перезагрузите компьютер.
pause
