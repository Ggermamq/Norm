@echo off
REM ============================================================
REM 08_STORAGE_SSD: отключить гибернацию (освобождает hiberfil.sys =
REM объём RAM * 40-100% на системном SSD) + запрет отключения дисков
REM в плане питания. Из старого "Гибернация ssd.reg" + "SSD Tweak.bat"
REM (старый bat был повреждён кодировкой; смысл — disable class
REM power policy — восстановлен корректно).
REM Откат: powercfg /setactive SCHEME_ORIGINAL или _RESTORE\Restore_Power.bat
REM ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Запустите от имени администратора.
    pause
    exit /b 1
)

powercfg /hibernate off

REM Диски: никогда не отключать для экономии энергии (AC и DC)
powercfg /setacvalueindex SCHEME_CURRENT SUB_DISK DISKIDLE 0
powercfg /setdcvalueindex SCHEME_CURRENT SUB_DISK DISKIDLE 0
REM Режим производительности NVMe (если драйвер поддерживает)
powercfg /setacvalueindex SCHEME_CURRENT SUB_DISK 540a9f07-d3c6-4a4e-a1d6-ebc8c0b0a2d0 0 2>nul
powercfg /setactive SCHEME_CURRENT

echo Готово.
pause
