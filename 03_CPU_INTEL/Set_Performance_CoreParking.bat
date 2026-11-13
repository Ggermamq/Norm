@echo off
REM ============================================================
REM 03_CPU_INTEL: максимум производительности CPU для активного
REM плана питания: парковка ядер OFF, мин. процессор 100%,
REM Turbo агрессивный, C-states через powercfg (не BIOS).
REM Откат: _RESTORE\Restore_Power.bat
REM ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Запустите от имени администратора.
    pause
    exit /b 1
)

echo Применение настроек CPU для активного плана...

REM Минимальное/максимальное состояние процессора 100% (без парковки)
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR MINCOREPCT 100
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR MAXCOREPCT 100
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 1
REM 1 = Aggressive (Intel); если значение не принято — используйте 0..3 из панели
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMAXCORES 100
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPINCREASETHRESHOLD 50
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPDECREASETHRESHOLD 50
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IDLEDCSTATES 0
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR IDLEACSTATES 0

powercfg /setactive SCHEME_CURRENT

echo Готово. Проверить: powercfg /query SCHEME_CURRENT SUB_PROCESSOR
pause
