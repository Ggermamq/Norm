@echo off
REM ============================================================
REM 09_STORAGE_HDD: отключить парковку головок (HIPM/DIPM) — из старого
REM набора ("Disable HDD Parking.bat"), исправлено: добавлен missing
REM enableextensions для !STR!, проверки и лог.
REM Парковка = 1-3 секундные фризы при обращении к игре на HDD!
REM Если игра установлена на SSD — этот файл НЕ нужен.
REM Откат: тот же скрипт с /d 1 или _RESTORE\Restore_Storage.reg
REM ============================================================

setlocal EnableExtensions EnableDelayedExpansion

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Запустите от имени администратора.
    pause
    exit /b 1
)

FOR /F "eol=E tokens=*" %%a in ('REG QUERY "HKLM\SYSTEM\CurrentControlSet\Services" /S /F "EnableHIPM" ^| FINDSTR /R "^HKLM"') DO (
    REG ADD "%%a" /F /V "EnableHIPM" /T REG_DWORD /d 0 >NUL 2>&1
    REG ADD "%%a" /F /V "EnableDIPM" /T REG_DWORD /d 0 >NUL 2>&1
    REG ADD "%%a" /F /V "EnableHDDParking" /T REG_DWORD /d 0 >NUL 2>&1
    SET STR=%%a
    SET STR=!STR:HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\=!
    ECHO Парковка отключена в: !STR!
)

REM Также запретить отключение диска планом питания (см. 08 SSD bat, действует глобально)
powercfg /setacvalueindex SCHEME_CURRENT SUB_DISK DISKIDLE 0
powercfg /setactive SCHEME_CURRENT

echo.
echo Готово. Перезагрузитесь.
pause
