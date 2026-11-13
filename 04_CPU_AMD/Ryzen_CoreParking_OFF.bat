@echo off
REM ============================================================
REM 04_CPU_AMD: отключить парковку ядер и установить 100% мин.
REM состояние процессора (Ryzen: держит все ядра в boost-окне,
REM убирает микрофризы от пробуждения ядер).
REM ВАЖНО: на Ryzen НЕ ставьте "мин. проц 100%" если CPU горячий —
REM вместо этого используйте Eco/Boost tuning в BIOS или Ryzen Master.
REM Откат: _RESTORE\Restore_Power.bat
REM ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Запустите от имени администратора.
    pause
    exit /b 1
)

powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMAXCORES 100
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPINCREASETHRESHOLD 90
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPDECREASETHRESHOLD 90
powercfg /setactive SCHEME_CURRENT

echo Готово. Для контроля температур используйте HWiNFO64.
pause
