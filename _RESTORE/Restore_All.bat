@echo off
REM ============================================================
REM _RESTORE: полный откат ВСЕХ твиков пакета CS2 Tweaks v2.
REM Запускать от имени администратора, затем перезагрузка.
REM ============================================================

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Запустите от имени администратора.
    pause
    exit /b 1
)

echo [1/6] Откат реестра (общие настройки)...
reg import "%~dp0Restore_Common.reg"

echo [2/6] Откат BCD-таймеров...
bcdedit /deletevalue disabledynamictick >nul 2>&1
bcdedit /deletevalue useplatformtick >nul 2>&1
bcdedit /deletevalue tsctimerpolicy >nul 2>&1

echo [3/6] Откат сети (netsh к дефолту)...
netsh int tcp set global ecncapability=disabled
netsh int tcp set global autotuninglevel=normal
netsh rsc set rscstate default
for /f "tokens=2 delims= " %%G in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" ^| findstr "Interfaces\\"') do (
    reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%G" /v TCPNoDelay /f >nul 2>&1
    reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%G" /v TcpAckFrequency /f >nul 2>&1
)

echo [4/6] Откат служб (возврат автозапуска)...
sc config DiagTrack start= delayed-auto >nul 2>&1
sc config SysMain start= auto >nul 2>&1
sc config WSearch start= auto >nul 2>&1
sc config Spooler start= auto >nul 2>&1
sc config lfsvc start= manual >nul 2>&1
sc config wuauserv start= manual >nul 2>&1
sc config UsoSvc start= delayed-auto >nul 2>&1
sc config NvContainerLocalSystem start= auto >nul 2>&1
sc config NVDisplay.ContainerLocalSystem start= auto >nul 2>&1

echo [5/6] Электропитание: сбалансированный план + возврат параметров...
powercfg -duplicatescheme 381b4dd6-9693-4e04-b764-3c9a8a4b1b42 >nul 2>&1
for /f "tokens=2" %%G in ('powercfg -list ^| findstr "381b4dd6"') do powercfg -setactive %%G
powercfg /hibernate on >nul 2>&1

echo [6/6] Память/диск: удаление наших значений (вернётся дефолт Windows)...
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Device" /v MaxIORequests /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\storahci\Parameters\Device" /v QueueDepth /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Storage" /v StorageD3InModernStandby /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\USB" /v DisableSelectiveSuspend /f >nul 2>&1

echo.
echo Откат завершён. ПЕРЕЗАГРУЗИТЕ КОМПЬЮТЕР.
pause
